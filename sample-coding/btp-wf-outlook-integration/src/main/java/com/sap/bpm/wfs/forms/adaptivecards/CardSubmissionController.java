package com.sap.bpm.wfs.forms.adaptivecards;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.Scanner;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPatch;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.sap.bpm.wfs.forms.adaptivecards.cardvalidation.ActionableMessageTokenValidationResult;
import com.sap.bpm.wfs.forms.adaptivecards.cardvalidation.ActionableMessageTokenValidator;
import com.sap.bpm.wfs.forms.adaptivecards.config.MailConfig;
import com.sap.bpm.wfs.forms.adaptivecards.config.VcapConfig;
import com.sap.bpm.wfs.forms.adaptivecards.util.HttpUtils;
import com.sap.bpm.wfs.forms.adaptivecards.util.UaaUtils;
import com.sap.cloud.sdk.cloudplatform.connectivity.*;

/**
 * Handles actions on Microsoft Adaptive Cards triggered by users in Microsoft
 * Outlook and completes tasks in CP Workflow.
 */
@RestController
public class CardSubmissionController {

    private static final Logger LOG = LoggerFactory.getLogger(CardSubmissionController.class);

    // The Organization Info in the Actionable Email Developer Dashboard
    // https://outlook.office.com/connectors/oam/publish
    @Value("${organization.id}")
    private String orgId;

    @Autowired
    private VcapConfig vcapConfig;

    @Autowired
    private MailConfig mailConfig;

    @Value("${card.submission.url}")
    private String cardSubmissionUrl;

    @Autowired
    private TaskRetriever taskRetriever;

    private static final String ACCEPT = "ACCEPT";
    private static final String APPLICATION_JSON = "application/json";
    private static final String CONTENT_TYPE = "Content-type";
    private static final String DESTINATION = "MSGraphAPI";

    @RequestMapping(value = "/submit-card/{taskId}/action/{actionId}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<String> submitCard(@PathVariable String taskId, @PathVariable String actionId,
            @RequestHeader(value = "Authorization") String auth, @RequestBody String body)
            throws ParseException, IOException {
        LOG.info("Submitting card for task {} with action {} and body {}...", taskId, actionId, body);

        // The email address used to send the Adaptive Card
        try {
            mailConfig.updateCredentialsFromDestination();
        } catch (IllegalStateException | RemoteAccessException e) {
            LOG.error("Mail configuration could not be retrieved");
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        String sender = mailConfig.getMailUser();

        ActionableMessageTokenValidator validator = new ActionableMessageTokenValidator();
        ActionableMessageTokenValidationResult result = validator.validateToken(auth, cardSubmissionUrl, orgId, sender);
        if (!result.getValidationSucceeded()) {
            if (result.getException() != null) {
                LOG.error("Error occurred while submitting card for task " + taskId, result.getException());
            }
            if (!result.getErrors().isEmpty()) {
                for (String error : result.getErrors()) {
                    LOG.error("Validation of token failed while submitting card {}: {}", taskId, error);
                }
            }

            HttpHeaders headers = new HttpHeaders();
            headers.add("CARD-ACTION-STATUS", "Authentication failed. Please contact your help desk.");
            return new ResponseEntity<>(null, headers, HttpStatus.UNAUTHORIZED);
        }

        // TODO: Check the task performer also was assigned to the task
        // in the workflow by querying the task instance REST API
        // and returning HTTP 403 if this was not the case

        // TODO: Propagate the principal signed into Outlook 365 to this API call
        // and complete the task on the principal's behalf

        String accessToken = null;
        try {
            accessToken = UaaUtils.getWorkflowAccessToken(vcapConfig);
        } catch (IllegalStateException e) {
            LOG.error("Access token for task {} is invalid", taskId);
            HttpHeaders headers = new HttpHeaders();
            headers.add("CARD-ACTION-STATUS", "Authentication failed. Please contact your help desk.");
            return new ResponseEntity<>(null, headers, HttpStatus.UNAUTHORIZED);
        } catch (RemoteAccessException e) {
            LOG.error("Access token for task {} could not be obtained", taskId);
            HttpHeaders headers = new HttpHeaders();
            headers.add("CARD-ACTION-STATUS", "There was an error processing your request.");
            return new ResponseEntity<>(null, headers, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        ResponseEntity<String> workflowResponce = submitCardToWorkflow(taskId, actionId, accessToken);

        if (workflowResponce.getStatusCodeValue() != 200) {
            return workflowResponce;
        } else {
            if (actionId.equals("decline")) {
                return workflowResponce;
            } else {
                return creatCalendarItem(taskId, actionId, body);
            }
        }

    }

    /*
     * Processes the card and submits the user's action to CP Workflow.
     */
    private ResponseEntity<String> submitCardToWorkflow(String taskId, String actionId, String accessToken) {
        String workflowAPI = vcapConfig.getWorkflowRestUrl();
        String taskInstanceUrl = workflowAPI + "/v1/task-instances/" + taskId;
        HttpPatch httpPatch = new HttpPatch(taskInstanceUrl);
        httpPatch.setHeader("Authorization", "Bearer " + accessToken);
        httpPatch.setHeader("Content-Type", "application/json");
        httpPatch.setHeader("Accept", "application/json");
        String json = "{\"status\": \"COMPLETED\", \"decision\": \"" + actionId + "\"}";
        //String json = "{\"context\": {\"result\": \"" + actionId + "\"}, \"status\": \"COMPLETED\"}";
        StringEntity entity;
        try {
            entity = new StringEntity(json);
        } catch (UnsupportedEncodingException e) {
            LOG.error("Server does not support the default HTTP charset", e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        httpPatch.setEntity(entity);

        try (CloseableHttpClient httpclient = HttpClients.createDefault();
                CloseableHttpResponse response = httpclient.execute(httpPatch);
                InputStream content = HttpUtils.getContent(response, "{}");
                Scanner scanner = new Scanner(content, "utf-8")) {
            ObjectNode responseNode = (ObjectNode) new ObjectMapper().readTree(scanner.useDelimiter("\\A").next());

            int status = response.getStatusLine().getStatusCode();
            HttpHeaders headers = new HttpHeaders();
            switch (status) {
                case 204:
                    headers.add("CARD-ACTION-STATUS", "The task was completed.");
                    return new ResponseEntity<>(null, headers, HttpStatus.OK);
                case 400:
                    if ("bpm.workflowruntime.rest.task.final.status"
                            .equalsIgnoreCase(responseNode.path("error").path("code").asText())) {
                        headers.add("CARD-ACTION-STATUS", "The task was already completed.");
                        return new ResponseEntity<>(null, headers, HttpStatus.BAD_REQUEST);
                    }
                    // fall through here...
                default:
                    headers.add("CARD-ACTION-STATUS", "There was an error processing your request.");
                    LOG.error("Error while completing task {} with action {}: {}", taskId, actionId,
                            responseNode.asText());
                    return new ResponseEntity<>(null, headers, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (IOException e) {
            LOG.error("Error while completing task " + taskId + " with action " + actionId, e);

            HttpHeaders headers = new HttpHeaders();
            headers.add("CARD-ACTION-STATUS", "There was an error processing your request.");
            return new ResponseEntity<>(null, headers, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    private ResponseEntity<String> creatCalendarItem(String taskId, String actionId, String body) {

        String accessToken = UaaUtils.getWorkflowAccessToken(vcapConfig);
        String workflowAPI = vcapConfig.getWorkflowRestUrl();
        // TaskRetriever taskRetriever = new TaskRetriever();

        String taskInstanceContext = taskRetriever.getTaskInstanceContext(taskId, accessToken, workflowAPI);
        JSONObject taskContext = new JSONObject(taskInstanceContext);
        JSONObject outlookBlocker = createOutlookRequestBody(taskContext);
        String requestorEmail = taskContext.getString("requestor");

        StringEntity httpPayload;
        try {
            httpPayload = new StringEntity(outlookBlocker.toString());
        } catch (UnsupportedEncodingException e) {
            LOG.error("Server does not support the default HTTP charset", e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        HttpDestination destination = DestinationAccessor.getDestination(DESTINATION).asHttp();
        HttpPost httpPost = new HttpPost(destination.getUri() + "/v1.0/users/" + requestorEmail + "/calendar/events");
        HttpClient client = HttpClientAccessor.getHttpClient(destination);
        httpPost.setEntity(httpPayload);
        httpPost.setHeader(ACCEPT, APPLICATION_JSON);
        httpPost.setHeader(CONTENT_TYPE, APPLICATION_JSON);

        try {
            HttpResponse httpResponse = client.execute(httpPost);
            int status = httpResponse.getStatusLine().getStatusCode();
            HttpHeaders headers = new HttpHeaders();
            switch (status) {
                case 201:
                    headers.add("CARD-ACTION-STATUS",
                            "The task has completed and the calendar item has been sent to the requester");
                    return new ResponseEntity<>(null, headers, HttpStatus.OK);
                default:
                    headers.add("CARD-ACTION-STATUS", "There was an error processing graphAPI for calendar");
                    LOG.error("Error while creating calendar item for task {} with action {} and status {}", taskId,
                            actionId, status);
                    return new ResponseEntity<>(null, headers, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (IOException e) {
            LOG.error("Error while creating calendar item for task " + taskId + " with action " + actionId, e);
            HttpHeaders headers = new HttpHeaders();
            headers.add("CARD-ACTION-STATUS", "There was an error processing your request.");
            return new ResponseEntity<>(null, headers, HttpStatus.INTERNAL_SERVER_ERROR);
        }

    }

    private JSONObject createOutlookRequestBody(JSONObject taskContext) {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date sDate, eDate;
        try {
            sDate = format.parse(taskContext.getString("startdate"));
            eDate = format.parse(taskContext.getString("enddate"));
        } catch (JSONException | java.text.ParseException e) {
            throw new JSONException("Error while parsing Date", e);
        }

        LocalDate startDate = sDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate endDate = eDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

        JSONObject outlookBlockerBody = new JSONObject();
        outlookBlockerBody.put("contentType", "HTML");
        outlookBlockerBody.put("content", taskContext.getString("reason"));

        JSONObject outlookBlockerStart = new JSONObject();
        outlookBlockerStart.put("dateTime", startDate.toString());
        outlookBlockerStart.put("timeZone", "Europe/Berlin");

        JSONObject outlookBlockerEnd = new JSONObject();
        outlookBlockerEnd.put("dateTime", endDate);
        outlookBlockerEnd.put("timeZone", "Europe/Berlin");

        JSONObject outlookBlockerLocation = new JSONObject();
        outlookBlockerLocation.put("displayName", taskContext.getString("reason"));

        JSONObject outlookBlockerEmail = new JSONObject();
        outlookBlockerEmail.put("address", taskContext.getString("requestor"));
        outlookBlockerEmail.put("name", taskContext.getString("requestorName"));

        JSONObject outlookBlockerAttendees = new JSONObject();
        outlookBlockerAttendees.put("emailAddress", outlookBlockerEmail);
        outlookBlockerAttendees.put("type", "required");
        JSONArray outlookBlockerAttendeesArray = new JSONArray();
        outlookBlockerAttendeesArray.put(outlookBlockerAttendees);

        JSONObject outlookBlocker = new JSONObject();
        outlookBlocker.put("subject", taskContext.getString("reason"));
        outlookBlocker.put("body", outlookBlockerBody);
        outlookBlocker.put("start", outlookBlockerStart);
        outlookBlocker.put("end", outlookBlockerEnd);
        outlookBlocker.put("location", outlookBlockerLocation);
        outlookBlocker.put("attendees", outlookBlockerAttendeesArray);
        outlookBlocker.put("showAs", "oof");

        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate);
        if (daysBetween > 1) {
            outlookBlocker.put("isAllDay", true);
        }

        return outlookBlocker;
    }

}
