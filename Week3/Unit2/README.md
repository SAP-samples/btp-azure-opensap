This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 


# SAP Workflow Management: Build Leave Request workflow

The objective of the exercise is to create a leave request workflow definition, deploy and run it on SAP BTP Trial. Also understand the basic concepts of how it all fits together.

## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week3Unit1, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](../../images/opensap-forum.png)

## Step 1 - SAP Business Application Studio getting started

1.1. Launch SAP Business Application Studio from BTP cockpit
   
   ![SAP Business Application Studio launch](./images/bas_launch.png)

1.2. Start the development space that you have created in the previous unit. (e.g. _WFDEV_). 
   
   ![Start WF Dev Space](./images/bas_start_space.png)

1.3. Open the space through clicking on the name. The SAP Business Application Studio will initiate all necessary tools. 
   
   ![Open WF Dev Space](./images/bas_wf_space.png)

1.4. You are now prompted with the _Welcome Page_ of your SAP Business Application Studio developement space. You are ready to go. 
   
   ![SAP Business Application Studio WF Dev Space](./images/bas_ready.png)


## Step 2 - Clone the Workflow project from GitHub and get familiar with it

2.1. Clone the GitHub repository of this openSAP course using the terminal in SAP Business Application Studio. 

Open the Terminal via the SAP Business Application Studio Menu. 
   ![Open Terminal](./images/openTerminal.png)

Change the directory and clone the git repository using the following commands: 

   ```bash
   cd ~/projects/
   git clone https://github.com/SAP-samples/btp-azure-opensap
   ```

   ![Change and clone](./images/changeAndClone.png)

2.2 Open the cloned project in the File Explorer. 

   ![Open the project in the File Explorer](./images/open_folder_filexplorer.png)

2.3. The cloned repository not only contains the exercises like this one here but also sample coding. The relevant artifacts for this unit are part of the following structure:

   ![WF Project structure](./images/wf_project_structure.png)

2.4. The Leave Request workflow definition relevant for this unit can be found in **sample coding > btp-workflow > LeaveRequest > workflows**. Open the file and have a look at it. 
   
   ```
   workflows
   └── EmployeeLeaveRequest.workflow
   ```

   ![WF Definition](./images/wf_definiition.png)

   The Leave request workflow definition consist of following tasks:
    
   * **User Task:** A flow object that illustrates a task that a human performs. User tasks appear e.g. in My Inbox where the processor of the task can complete the task instance, and view its description.
   * **Mail Task:** A flow object that you configure to send e-mails to one or more recipients.
  
   >If you are interested in further task types, please refer to following  [documentation]([https://link](https://help.sap.com/viewer/e157c391253b4ecd93647bf232d18a83/Cloud/en-US/a855a4f8898547bd8a5aa04bf7ecaa40.html))

   As a **User Task** (ApproveOrRejectManager) we defined all the fields and forms necessary for manager to approve or reject the leave request.

   **Mail Task** (MailTaskAccept, MailTaskDecline) we use to send the leave requester the approval status.

2.4. The Form definition for the said User Task is defined in the following file. Open the file and have a look at it. 
      
   ```
   forms
   └── EmployeeLeaveRequest
       └── ManagerApproval.form
   ```

   ![WF Form](./images/wf_form.png)

   End users can interact with a workflow through user interface with forms. In this example, the manager of an employee can see the request form in the MyInbox application and approve or reject the request.

2.5. To test the leave request workflow, the project contains a sample data file that can be used for testing purpose during the workflow development. Open the file and have a look at it. 
   
   ```
   sample-data
   └── EmployeeLeaveRequest
       └── sampleContext.json
   ```
   
   ![WF Sample Data](./images/wf_sample_data.png)

   ```json
   {
    "requestorName": "Requestor Name",
    "reason": "Vacation",
    "requestor": "Requestor E-Mail (Use the address used in BTP)",
    "startdate": "2021-12-16",
    "enddate": "2021-12-19"
   }
   ```

   >Note, To keep this scenario as simple as possible, you will take both the role of a potential manager and approve or reject the leave request created by you as well as the role of the leave request creator. 
   
## Step 3 - Build and deploy the Workflow in your BTP trial account

After exploring the leave request workflow definition, you can build and deploy it to your SAP BTP trial account.

---

3.1. Make sure that you are loged in your SAP BTP Cloud Foundry environment. Therefore, you need an API Endpoint. **Open the SAP BTP Trial Cockpit in a new tab** (you still need the SAP Business Application) and navigate to your dev space.

   ![Space Overview](./images/dev_space.png)

3.2 **Copy** the API Endpoint. 

   ![Space Overview](./images/api_endpoint.png)

3.3 Go back to the SAP Business Application Studio tab and use the following command. **Replace** the _<API Endpoint>_ placeholder with the actual value you have copied from the SAP BTP Trial Cockpit. 

   bash
   ```
      cf login -a <API Endpoint>
   ```

   [Space Overview](./images/cf_login.png)

> Note: If you only have access to one Cloud Foundry space, then you are automatically target to this one. (If there are multiple spaces accessible for you, follow the progress in the terminal and provide the org/space numbers.)

3.4. Right click on the **sample-coding/btp-workflow/mta.yaml and select **Build MTA Project**.
   
   ![WF Build](./images/wf_build.png)

   > mta.yaml is the [Multitarget Application development descriptor](https://help.sap.com/viewer/4505d0bdaf4948449b7f7379d24d0f0d/2.0.03/en-US/4486ada1af824aadaf56baebc93d0256.html)

   The build step will produce the following file **sample-coding/btp-workflow/mta_archives/LeaveRequest_0.0.1.mtar. 

   ```
   mta_archives
   └── LeaveRequest_0.0.1.mtar
   ```

3.5 Right click on the LeaveRequest_0.0.1.mtar file and select **Deploy MTA Archive**. 
   
   ![WF Deploy](./images/wf_deploy.png)

## Step 4 - Define the Mail Destination used in Mail task to send the approval status

To be able to send approval or rejection email from Mail Task, we need to configure mail destination with SMTP credentials.

4.1. Download the **"bpmworkflowruntime_mail"** destination from GitHub or from your SAP Business Application Studio workspace
   
   ![WF Mail Destination Download](./images/wf_destination_download.png)

   ```
   sample-coding
   └── btp-wf-outlook-integration
       └── bpmworkflowruntime_mail
   ```

4.2. Go to BTP cockpit and navigate to destinations and import the downloaded mail destination
   
   ![WF Import the mail destination](./images/wf_import_destination.png)

4.3. Add your SMTP Server host and credentials
   
   ![WF Mail Destination](./images/wf_mail_destination.png)

   >Note, the destination name should be **bpmworkflowruntime_mail**, otherwise the Workflow Mail Task will not find it.

   ```
      Type=MAIL
      Name=bpmworkflowruntime_mail
      ProxyType=Internet

      mail.user=
      mail.password=
      
      mail.smtp.host=mail.example.com
      mail.smtp.port=587
      mail.transport.protocol=smtp
      mail.smtp.starttls.required=true
      mail.smtp.starttls.enable=true
      mail.smtp.connectiontimeout=50000
      mail.smtp.timeout=50000
      mail.smtp.auth=true
      
      mail.smtp.from=cpworkflow@example.com
      mail.smtp.ssl.checkserveridentity=true
      
      mail.bpm.send.disabled=false

   ```
    >Replace the SMTP host *mail.smtp.host* and *mail.smtp.from* also provide the credentials of SMTP Server.

    >Note: For Office 365 use the SMTP server: smtp.office365.com

## Step 5 - Test the workflow definition 

After successful deployment of leave request workflow we can see the deployment and test it with sample leave request

5.1. Go to BTP Cockpit and navigate to **"Instances and Subscriptions"** and run the **"Workflow Management"** using the highlighted icon
   
   ![WF launch](./images/wf_manag_launch.png)
   
   It will open Workflow Management launchpad

5.2. In launchpad under Monitoring tools you can find the "Workflow Monitoring - Workflow Definition" tile. Open the application
   
   ![WF monitoring](./images/wf_monitoring.png)

5.3. Here you can find the Employee Leave Request Workflow deployed in previous steps
   
   ![WF leave request](./images/wf_employee_lr.png)

5.4. Now you can trigger new Leave Request Workflow by clicking on **"Start new instance"** and using the sample data we defined in earlier steps.

   ![WF new instance](./images/wf_new_instance.png)

   >Note, later in upcoming Unit the leave request workflow will be triggered by API call from CAI chatbot

5.5. Go back to Workflow Management launchpad and open "Workflow Monitoring - Workflow Instances" tile

   ![WF monitoring instances](./images/wf_monitoring_instances.png)

5.6. Here you can find the running instance of triggered workflow

   ![WF running instances](./images/wf_running_instance.png)

   You can find detailed information about the triggered workflow, see the workflow context and also analyse execution log if necessary.
   
   In Execution log you can see that leave request task was created and the manager can find it in MyInbox application.

   To keep the exercise simple, you will take the role of manager and approve or reject the leave request created by you.

5.7. Go back to launchpad and launch **"My Inbox"** application
   
   ![WF start My Inbox](./images/wf_myinbox.png)

5.8. In My Inbox you will find the triggered leave request and you can "self" approve or reject it.

   ![WF approve or reject](./images/wf_accept_reject.png)

5.9. After approval or rejection you will receive confirmation/rejection E-Mail

   ![WF E-Mail](./images/wf_approval_email.png)
    
5.10. In Workflow Monitoring under Execution Log you can see that all steps were successfully finished.
    
   ![WF Execution log](./images/wf_execution_log.png)
   

## Summary

Congrats! You successfully build and deployed the leave request workflow. You also simulated the workflow request process using the Monitoring tools provided by SAP Workflow Management.
