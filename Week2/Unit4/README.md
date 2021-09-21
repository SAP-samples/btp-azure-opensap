This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 

# SAP Cloud Integration and Azure Traffic Manager - intelligent routing. 

**DISCLAIMER: This exercise cannot be done in the SAP BTP Trial environment**

Extending your SAP S/4HANA business processes with SAP Business Technology Platform (BTP) includes making sure that you are ready to handle disaster recovery scenarios. When your SAP backend performs a failover, BTP workloads need to switch too. This can happen on configuration or on deployment level and involves adding an abstraction layer which is able to switch routing targets without the need to touch SAP S/4HANA backend configuration. For a timely recovery of the service chain, we need to apply automation to the process.

![Scenario explanation](./images/scenario.png)

Furthermore, decoupling of the connection allows scaling of the endpoints globally as close to the end-users as possible, minimizing latency, increasing up-time and performance. Different routing techniques like performance-based, availability-based, weighted, or geo-based are typically used.

In this mission you will learn how to run multiple SAP Cloud Integration tenants (SAP Integration Suite) in parallel to apply the mechanisms mentioned above. Azure Traffic Manager will play a significant role in routing the traffic intelligently to different SAP Cloud Integration tenants.

From a service perspective, you'll be using a number of SAP BTP and Microsoft services:
* **SAP Integration Suite**: The SAP Integration Suite helps you to quickly develop and manage reliable communication between applications, services, and systems.
* **SAP Custom Domain Service**: The SAP Custom Domain service lets you configure your own custom domain to expose publicly your application instead of using the default subdomain.
* **SAP Cloud Transport Management**: SAP Cloud Transport Management service lets you manage software deliverables between accounts of different environments (such as Neo and Cloud Foundry), by transporting them across various runtimes. This includes application artifacts as well as their respective application-specific content.
* **Azure Traffic Manager**: Azure Traffic Manager is a DNS-based traffic load balancer. This service allows you to distribute traffic to your public facing applications across regions. Traffic Manager also provides your public endpoints with high availability and quick responsiveness.


Entitlements/Quota required in your SAP Business Technology Platform Account:

| Service                     | Plan             | Number of instances |
| --------------------------- | ---------------- | ------------------- |
| Process Integration Runtime | integration-flow | 2                   |
| Process Integration Runtime | api              | 2                   |
| Custom Domain Service       | Custom Domain    | 2                   |


Subscriptions required in your SAP Business Technology Platform Account:

| Subscription               | Plan                                                   |
| -------------------------- | ------------------------------------------------------ |
| Integration Suite          | Standard Edition or Digital Edition or Premium Edition |
| Cloud Transport Management | saas-application                                       |


## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week2Unit1, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](./images/opensap-forum.png)


## Step 1 - Setup SAP Cloud Integration

> Note: Even if you have set up the SAP Cloud Integration tenant (in SAP BTP Trial) in the previous step, please make sure that you follow the exercise for an enterprise SAP BTP environment here.

In this step, you will setup two SAP Cloud Integration tenants in two different regions. 

**IMPORTANT: Therefore, two subaccounts in two different regions are necessary.** Not only will you subscribe to the SAP Integration Suite but further on provision the SAP Cloud Integration tenant and assign the needed roles to your user. 

---

1.1 If you haven't used SAP Business Technology Platform or SAP Cloud Integration yet, please go to the SAP Discovery Center Mission [Get Started with Integration Suite - Cloud Integration](https://discovery-center.cloud.sap/missiondetail/3258/3327/?tab=projectboard)_

1.2 Go to your SAP BTP Cockpit and make sure that you have two subaccounts in your global account. In this case, we have both of them on Azure - one in West Europe (Netherlands, EU20), one in West US (WA, US20). If you don't have them yet, click on **New Subaccount** in order to create a new subaccount. 

![New subaccount](./images/01.png)

> NOTE: If you already have two subaccounts in regions where the [SAP Integration Suite is available](https://discovery-center.cloud.sap/serviceCatalog/integration-suite?region=all&tab=service_plan), you don't necessarily need to create separate accounts for this unit. You can simply reuse the existing ones, if you want.

1.3. Provide the necessary details for the new subaccount. 

   - Provide a subaccount name. 
   - Optional: Provide a description. 
   - Select Provider **Azure**. 
   - Select Europe (Netherlands) or another region, where SAP Integration Suite is available. The [SAP Discovery Center](https://discovery-center.cloud.sap/serviceCatalog/integration-suite?region=all&tab=service_plan) shows the available regions.  
   - Enter a Subdomain for your subaccount. This subdomain becomes part of the URL for accessing applications that you subscribe to from this subaccount.
   - Optional: If your subaccount is to be used for productive purposes, select the **Used for production** option.

![Subaccount details](./images/02.png)

1.4. Save your changes. 

**A new tile appears in the global account page with the subaccount details.**

1.5 Make sure that you have two subaccounts in regions where the SAP Integration Suite is available. If you don't have two subaccounts for SAP Integration Suite yet, create another subaccount as explained in Step 1.3.-1.4. 

1.6 In the navigation area of the global account, choose **Entitlements > Entity Assignments** and select the subaccounts in which you want to set up SAP Integration Suite. Continue with **Go**. 

![Entity Assignment filter](./images/03.png)  

1.7 Go to **Configure Entitlements** followed by **Add Service Plans** for the first subaccount. 

![Configure Entitlements](./images/04.png)  
![Add Service Plans](./images/05.png)  

1.8 Add the following entitlements: 

* SAP Integration Suite (Service Plan: standard_edition or digital_edition or premium_edition)
* Process Integration runtime (Service Plan: integration-flow)
* Process Integration runtime (Service Plan: api)
* Custom Domain Certificates (Service Plan: custom_domains)

1.9  **Save** the changes. 

![Save Entitlement Assignments](./images/06.png)  

1.10  **Repeat steps 1.7-1.9 also for the second subaccount.**

1.11. Go to **Subaccounts** and navigate to the first subaccount for the SAP Integration Suite. 

1.12 In the navigation area of the subaccount, choose **Services > Service Marketplace** and search for **Integration Suite**. Choose **Create** in the overview page.

![Create subscription](./images/07.png)  
![Create subscription](./images/08.png)  
    
1.13 In the **New Instance or Subscription** dialog box, select an available **Plan** and finish with **Create**. Wait for the subscription to complete successfully.
    
1.14 Check the status of the submission in subscriptions section on the **Instances and Subscriptions** page. If the subscription is successful you'll notice the status of the Integration Suite shown as **Subscribed**.

![Subscription status](./images/09.png)  

1.15 In the navigation area of the subaccount, choose **Security > Role Collections** and search for **Integration_Provisioner**. 

![Integration_Provisioner role collection](./images/10.png)  

1.16 Click on the Role Collection itself and **Edit**. 

![Integration_Provisioner role collection edit](./images/11.png) 
    
1.17 Enter the mail address for your SAP BTP user in the **User** section and **Save** your changes. Make sure that your user appears in the User section after you have saved the changes.

1.18 Go back (using the browser function, for instance) to the **Instances and Subscriptions** page. Select the **Integration Suite** Subscription and choose **Go to Application** to launch the Integration Suite Launchpad.

![Go to Integration Suite launchpad](./images/12.png) 

>The Integration Suite Launchpad is a common launchpad for provisioning and onboarding users to the Integration Suite capabilities. The provisioned users can access the activated capabilities and explore the resources needed for using the Integration Suite service. All the Integration Suite capabilities are represented as tiles on the launchpad.

>Note: In case if you are unable to view the Integration Suite Launchpad, see [SAP Note 2953114](https://launchpad.support.sap.com/#/notes/2953114) published on SAP Support page.

1.19 In the Integration Suite launchpad, under **Capabilities** section, choose **Add Capabilities**. The Provisioning application is launched.

![Click on the Add Capabilities button](./images/13.png) 

> Note: The Add Capabilities action is available only to users with Integration_Provisioner role.

1.20 Select the checkbox for **Design, Develop and Operate Integration Scenarios** (SAP Cloud Integration). Continue with **Next**.

![Design, Develop and Operate Integration Scenarios checkbox](./images/14.png) 

1.21 Select the desired environment type (e.g. **Non-Productive**). Continue with Next and **Activate** without any further modifications.

![choose environment type](./images/14a.png) 

1.22 Wait until Cloud Integration is activated. 

![activation status Cloud Integration in progress](./images/15.png)
![activation status Cloud Integration finished](./images/16.png)
    
1.23 Navigate to the Integration Suite Launchpad by choosing the Integration Suite button in the header.

![status Cloud Integration finished](./images/17.png)

The activated capabilities appear as tiles under the Capabilities section.

![status Cloud Integration finished](./images/18.png)

In the top-right corner of each capability tile, you can choose the icon to bring out options that let you manage and view additional details of a capability.

![capabilities option](./images/19.png)

> Note: This option is available only to users with Integration_Provisioner role.

1.24 Navigate back to SAP BTP Cockpit and select the subaccount in which you've setup the SAP Integration Suite tenant in the previous steps.

1.25 In the navigation area of the subaccount, choose **Security > Users** and select your user. An overview of already assigned role collections will show up. 

![assign role collections](./images/20.png)

1.26 Select **Assign Role Collection** and add the following Role Collections: 

- PI_Business_Expert	
- PI_Administrator
- PI_Integration_Developer	

> Find an overview of all Role Collections for the SAP Integration Suite on [help.sap.com](https://help.sap.com/viewer/51ab953548be4459bfe8539ecaeee98d/LATEST/en-US/2c6214a3228e4b4cba207f49fda92ed4.html)

1.27 Go to **Role Collections** in the navigation area and **create** a new Role Collection. 

![Create new Role Collection ](./images/21.png) 

1.28 Provide **CloudIntegrationSender** as the name and a description for the new Role Collection.

![Role Collection name and description](./images/22.png) 

1.29 Select the newly created Role Collection from the list of all Role Collections. 

1.30 Select **Edit** and add the **MessagingSend** role. 

![Role Collection edit](./images/23.png) 
![MessagingSend addition](./images/24.png) 
    
1.31 <a name="rolecollection-sender"></a>Enter your mail adress to assign the Role Collection to your user. 

![Role Collection assignment](./images/25.png) 

1.32 Continue with **Save**. 

> With the newly created Role Collection, you are later on able call Integration Flows or REST APIs deployed to the SAP Cloud Integration runtime. 

1.33 Go back to the subaccount. 

![Role Collection assignment](./images/26.png) 

1.34 Navigate to the **Instances and Subscriptions** page. Select the **Integration Suite** Subscription and choose **Go to Application** to launch the Integration Suite Launchpad again. 

![Go to Integration Suite launchpad](./images/12.png) 

1.35 In the Integration Suite Launchpad, choose the **Cloud Integration** tile to access the SAP Cloud Integration web interface. 

![Launch SAP Cloud Integration ](./images/27.png) 
![SAP Cloud Integration web interface](./images/28.png) 

> Note: Bookmark the SAP Cloud Integration web interface to have the URL handy whenever you need it without navigation through the SAP Integration Suite launchpad. 

1.36 **Repeat steps 1.11 - 1.35 also for the second subaccount.**

**You should now have two SAP Cloud Integration tenants in subaccounts of different regions. Congratulations!**

## Step 2 - Setup Monitoring Endpoint for Azure Traffic Manager

In this step, you will create a REST API in SAP Cloud Integration that will act as an auxiliary endpoint for Azure Traffic Manager. 

**Important:** The following steps need to executed for both SAP Cloud Integration tenants. 

---

2.1 Go to the SAP Cloud Integration web interface of your first subaccount, either via the SAP Integration Suite launchpad as shown in [Setting SAP Cloud Integration](../01-SetupCloudIntegration/README.md). 

2.2 <a name="download"></a>Open a new tab in your browser and go to https://github.com/SAP-samples/btp-azure-opensap/blob/main/sample-coding/btp-cloud-integration-flow/flow-azuretm.zip. **Download** the ZIP File containing the Integration Package with the sample REST API for SAP Cloud Integration.

![Download Button on GitHub](./images/29.png)

2.3 Go back to the SAP Cloud Integration web interface and choosse **Design** in the navigation area. 

![Navigate to the Design menu](./images/30.png)

> Note: You can expand the navigation area using the hamburger icon. 

2.4 Import the previously downloaded Integration Package (ZIP file from Step 2.2).  

![Import content package](./images/31.png)

2.6 Select the newly uploaded Integration Package called **Azure Traffic Manager**.

![Select new integration package](./images/32.png)

2.7 Go to the **Artifacts** tab and click on the **ping** artifact of type REST API to open the SAP Cloud Integration editor. 

![Select new REST API](./images/33.png)

You should now see a very basic REST API that offers an HTTP endpoint and returns a message using the HTTP body to the sender. This REST API is used for different purposes: 

- a) Azure Traffic Manager will call this REST API in both SAP Cloud Integration tenants in order to find out if the tenant is up and running. 
- b) A fictive sender will call this REST API and will get back which tenant was chosen by Azure Traffic Manager. 

2.8 Change into the **Edit** mode and confirm potential messages with **Yes**.

![changed into edit mode](./images/34.png)

2.9 Double-Click **Reply Tenant Identifier**.

![changed into edit mode](./images/35.png)

2.10 Select the **Message Body** tab so you can type in whatever message you want to reply to the sender. For testing purposes it helps, if you replace the placeholder with the subaccount region, the current SAP Cloud Integration instance is located in. That way, you can easily identify which tenant is handling the traffic routed by Azure Traffic Manager. 

![replace placeholder Message Body](./images/36.png)

2.11 **Save** and **Deploy** the REST API. 

![Save and deploy](./images/37.png)

2.12 Open a new browser tab and navigate to your subaccount in the SAP BTP Cockpit. 

2.13 Create space in Cloud Foundry environment to control use of resources. Therefore, **Enable Cloud Foundry**. 

![Enable Cloud Foundry button](./images/38.png)

> If you already have a Cloud Foundry space, you can skip steps 2.13 - 2.16. 

2.14 Provide unique names for the instance and org name. 

2.15 Create a new Cloud Foundry space using the **Create Space** button.

![Create space button](./images/39.png)

2.16 Enter a space name and select the permissions you would like to assign to your ID and save the changes by using the **Create** button.
    
![space name and creation button](./images/40.png)

2.17 Select the newly created space. 

![space name and creation button](./images/41.png)
    
2.18 Go to **Services > Service Marketplace** and search for **Process Integration Runtime**.

![Process Integration Runtime tile](./images/42.png)

2.19 Select the tile and **Create** a instance of the Process Integration Runtime service.

![Service instance creation](./images/43.png)

2.20 In the New Instance or Subscription dialog box, select the Plan **integration-flow** and provide a instance name. Continue with **Next**.

![Service instance name and plan](./images/44.png)

2.21 In the Parameter menu switch to the **JSON** tab and insert the following content in the text area to assign roles. This authorizes the sender system to call a tenant and allows to process the messages on the tenant.

```json
{
    "roles": [
        "ESBMessaging.send"
    ]
}
```

> Note: The role name is case-sensitive and the authentication mode used is basic authentication.

![Service instance name and plan](./images/45.png)

2.22 Continue with **Create**. 

2.23 Select **View Instance** to see the progress of the service instance creation. 

![Service instance creation progress](./images/46.png)

2.24 <a name="servicekey"></a> In the Instance View, select **Create** in the **Service Keys** section to create a service key. 

![service key creation](./images/47.png)

2.25 Enter a name (e.g. sk1) for the service key and choose **Create**. 

2.26 Click on the recently created service key to retrieve the credential information from the service key. Keep this tab opened since you will need the credentials in one of the next steps.  

![service key detail](./images/48.png)

2.27 Go back to the tab with the SAP Cloud Integration web interface or open a new one. Navigate to the **Monitor** item in the navigation area. 

![SAP Cloud Integration Monitor section](./images/49.png)

2.28 In the **Manage Integration Content** area, select the **Started** tile to have a look at the REST API you have deployed in step 2.11. 

![SAP Cloud Integration Monitor section](./images/50.png)

2.29 <a name="endpoint"></a>Select **ping** and copy the endpoint URL of the REST API. 

![REST API endpoint](./images/51.png)

2.30 Open a terminal on your machine and try to execute the following command. 

```console
curl <endpoint_from_sapcloudintegration> -u '<clientid_from_servicekey>:<clientsecret_from_servicekey'
```

- <endpoint_from_sapcloudintegration> is the endpoint URL you have just copied in the SAP Cloud Integration web interface. 
- <clientid_from_servicekey> is the clientid value of the service key that you have created in step 25. 
- <clientsecret_from_servicekey> is the clientsecret value of the service key that you have created in step 25.

> The command could possibly look like: 
> curl https://mysubaccount.it-cpi003-rt.cfapps.eu20.hana.ondemand.com/http/ping -u 'sb-50162a35-56d0-4c06-adb0-3f315df3b0c3!b2657|it-rt-xxxxyzwzwze!b196:af36f2ea-561a-44a3-977d-831f8ed9d129$Ta8rQN1LMzY9l9SvowftrpclBRqHNGJDvaX07veirIx='

![Hit REST API endpoint](./images/52.png)

> Note: It could happen that Windows machines are trying to authenticate implicitly with certificates against the endpoint. This can cause problems. 
> In case you're facing the error message "The filename, directory name, or volume label syntax is incorrect.", encode special characters like '|' in the username. 

2.31 **Repeat steps 2.1 - 2.30 for the second subaccount.**

Congratulations! You have setup an endpoint in SAP Cloud Integration that will help Azure Traffic Manager to identify whether one of the tenants is online or not. For sure, this REST API only offers a straight forward way to determine, whether the tenant is able to handle an incoming request or not. It's up to you to implement a more sophisticated logic to identify, if a tenant should be the one prioritized by Azure Traffic Manager or not. 

## Step 3 - Map Custom Domain Routes

In this step, you will map the endpoints of the SAP Cloud Integration runtime to your custom domain using the SAP Custom Domain Service. Both of the SAP Cloud Integration runtime endpoints are then mapped to the same domain. 

This way, a sender connecting to SAP Cloud Integration must not use the region-specific endpoint information of the particular SAP Cloud Integration tenants but simply uses the custom domain. 

The steps below describe the process using a custom domain bought via Azure. The process for a domain coming from another domain provider should be relatively similar. 

**Important:** The following steps need to be executed for both of the subaccounts running your SAP Cloud Integration subscriptions. 

---

3.1 Install the Cloud Foundry CLI and make sure you have chosen the right API Endpoint (one of the subaccounts). Follow [this tutorial](https://developers.sap.com/tutorials/cp-cf-download-cli.html) in order to do so. 

3.2 Install the Custom Domain plugin for the Cloud Foundry CLI. Please follow [this tutorial](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/9f98dd0fcf9447019f233403f4ca60c1.html). 

3.3 Copy the **API Endpoint** and **Org Name** of your first subaccount to your clipboard. The information can be taken from the subaccount overview in the SAP BTP Cockpit. 
![API Endpoint](./images/53.png)

3.4 Log in to the right Cloud Foundry space that you have created in the previous steps using the following command. Insert the corresponding **API Endpoint** from the previous step. 

```
cf login -a <API_ENDPOINT>
```

3.5 Create an instance of the [Custom Domain Service](https://help.sap.com/viewer/product/CUSTOM_DOMAINS/Cloud/en-US) using the following command:

```
cf create-service INFRA custom_domains customdomain
```

3.6 Register your custom domain: 

```console
cf create-domain <cloudfoundry_org> example.com
```
> Note: Instead of example.com use your own domain that you have bought. Replace <cloudfoundry_org> with the **Org Name** you have copied from the subaccount overview in Step 3. 

3.7 Check if the domain was registered: 
```console
cf domains
```

3.8 Generate a new private and public key pair for this domain: 
   
```console
cf custom-domain-create-key key1 "CN=*.example.com, O=<Organization e.g. SAP>, L=<Location e.g. Walldorf>, C=<Country e.g. DE>" "*.example.com"
```

> Note: Provide actual values for Organization, Location and Country instead of the example values provided in the example command. 

![Create signing request](./images/54.png)

3.9  Download certificate signing request corresponding to the new key:

```console
cf custom-domain-get-csr key1 key1_unsigned.pem
```

![Download signing request](./images/55.png)

> Note: The file key1_unsigned.pem is downloaded to your current working directory. Use `pwd` (for Linux/macOs) or `dir` (Windows) to find out the current working directory.

3.10 Install certbot client on local machine. 

- for **Windows**: Download the latest version of the Certbot installer for Windows at https://dl.eff.org/certbot-beta-installer-win32.exe. Run the installer and follow the wizard. The installer will propose a default installation directory, C:\Program Files(x86)

- for macOS: execute ```brew install certbot``` to install the certbot client. 
> for all others: Go to https://certbot.eff.org/lets-encrypt/osx-other and choose "My HTTP website is running on **none of the above** on **choose your OS**. 

> **IMPORTANT**: The output of the certbot commands will look slightly different depending on your OS. Screenshots were taken with macOS. 

3.11 Sign the certificate signing request (with a domain bought from Azure): 

**Windows (console with administrative rights might be required):**
```console
certbot certonly --manual --preferred-challenges dns --server "https://acme-v02.api.letsencrypt.org/directory" --domain "*.example.com" --email your.mail@example.com --csr key1_unsigned.pem --no-bootstrap --agree-tos
```
**macOS**
```console
sudo certbot certonly --manual --preferred-challenges dns --server "https://acme-v02.api.letsencrypt.org/directory" --domain "*.example.com" --email your.mail@example.com --csr key1_unsigned.pem --no-bootstrap --agree-tos
```

![DNS Challenge 01](./images/56.png)

> Don't forget to fill in your domain and mail address instead of example.com! You now have to proof that you are in control of the domain - certbot is now executing a DNS challenge. 

3.12 Open a new broswer tab, go to the [Azure Portal](http://portal.azure.com) and navigate into the DNS zone of your bought domain. 

![DNS Zone Search](./images/57.png)
![DNS Zone selection](./images/58.png)

3.13 **Create a new record set** and enter the details that the certbot command (Step 8) has printed out. 

![Record creation in DNS Zone](./images/59.png)

3.14 Hit **Enter** in the Terminal (where you have recently executed the certbot command in Step 11) to continue the verification process. 

**Windows**

![Verification process continuation ](./images/60.png)

**macOS**

![Verification process continuation ](./images/61.png)

> IMPORTANT: sometimes it could happen that you have to repeat the last steps a few times, depending on the output in the terminal. 

3.15 Open the certificate chain that has been created in the previous step in a text editor of your choice. 

![Certificate in text editor](./images/62.png)

3.16 Open a new broswer tab, go to <https://www.identrust.com/dst-root-ca-x3> and copy the content of the entire DST Root CA X3 Certificate. 

> Don't forget to copy the entire content including '-----BEGIN CERTIFICATE-----' and '-----END CERTIFICATE-----'
    
3.17 Paste the content of the DST Root CA X3 Certificate to the end of the created certificate chain on your local machine that you have opened during step 15. Save it as a new file, for instance **certificate1.pem**. 

![Certificate in text editor](./images/63.png)

3.18 Upload and activate the certificates: 

```console
cf custom-domain-upload-certificate-chain key1 certificate1.pem
```

![Custom domain upload certificate](./images/64.png)

> Note: *key1* refers to the key you have created in Step 5, certificate.pem is the name of the file that you have created in the previous step.

3.19 Activate the custom domain: 

```console
cf custom-domain-activate key1 "*.example.com"
```

![Custom domain activation](./images/65.png)


3.20 Verify the custom domain activation: 

```console
cf custom-domain-list
```

![Custom domain activation verification](./images/66.png)

> Note: It can take a few minutes up to a few hours until the custom domain is activated. 

3.21 <a name="endpointmapping"></a>Finally, map the SAP Cloud Integration **runtime** endpoint to a subdomain of your domain: 

```console
cf custom-domain-map-route <endpoint_from_sapcloudintegration> cloudintegration.example.com
```

> Example: cf custom-domain-map-route mysubaccount.it-cpi003-rt.cfapps.eu20.hana.ondemand.com cloudintegration.saptfe-demo.com. 

> Note: If you don't know your SAP Cloud Integration runtime endpoint, go back to the [Step 2.28](#endpoint) - don't include a specific endpoint for an Integration flow or REST API, just the basic endpoint without any path. 

> Note: Most likely the TXT validation entry (step 14) does not need to be set again and can further be used. In this case, certbot will not ask for a renewal of the entry. 

3.22 **Execute all of the steps for the second subaccount!**

Congratulations! You have created a certificate for your domain using Certbot. With the help of the SAP Custom Domain Service you registered the domain in the subaccounts in which you also provisioned SAP Cloud Integration and mapped its runtime endpoints to the actual domain.

Keep in mind that the Let's Encrypt certificate (the one you have create using Certbot) is only valid for three months. There are other more sophisticated alternatives for productive scenarios. 

## Step 4 - Setup Azure Traffic Manager profile

In this step, you will configure Azure Traffic Manager (actually the Azure Traffic Manager profile). The Azure Traffic Manager profile is the key component in this *intelligent routing* scenario, as it defines which SAP Cloud Integration tenant should be used when, based on certain rules and policies. 

---

4.1 Go to the [Azure Portal](http://portal.azure.com) and log in. 

4.2 Search for **Traffic Manager profile** and select the corresponding item.

![Azure Traffic Manager profile search using Azure Portal](./images/67.png)

4.3 **Create** a new Traffic Manager profile. 

![Azure Traffic Manager profile search using Azure Portal](./images/68.png)

4.4 Provide a meaningful name (e.g. *cloudintegration-failover*) for the Azure Traffic Manager profile, select **Priority** as the Routing method and assign it to one of your subscriptions. If necessary, create a new Resource Group. 

![Azure Traffic Manager profile creation details](./images/69.png)

4.5 Continue with **Create**. 

4.6 Wait until the deployment was succesfully finished. Select **Go to resource** to navigate to the details of the profile.

> Alternatively you can also refresh the list of all Azure Traffic Manager profiles and select the recently created Traffic Manager profile.

![Traffic Manager profile details after deployment](./images/70.png)

4.7 Select **Configuration** in the navigation area. 

![Traffic Manager profile details after deployment](./images/71.png)

4.8 <a name="tm-configuration"></a>Provide the following settings: 

- Routing method: Priority
- DNS time to live (TTL): 1
- Protocol HTTPS
- Port: 443
- Path: /http/ping
- Expected Status Code Range: 200-200
- Probing interval: 10
- Tolerated number of failures: 1
- Probe timeout: 5

![Traffic Manager profile configuration settings](./images/72.png)

> **IMPORTANT**: Those settings enable the fatest failover that's possible based on DNS time to live & the **fast endpoint failover settings**. The more often the **monitor** endpoint (/http/ping) the higher the amount of messages the SAP Cloud Integration needs to handle. How often the monitor endpoint is called is defined by the combination of probe timeout and probing interval. Adjust the settings for your productive scenario depending on your needs. 

> Note: The path you have defined is later on used to monitor every defined endpoint in the Azure Traffic Manager profile. The exact path is then concatenated with the endpoints target that we'll define in one of the subsequent steps. **/http/ping* is the path of the REST API that you have deployed in one of the [previous steps](#endpoint).

4.9 Continue with **Save**.

4.10 Select **Endpoints** in the navigation area. 

![Traffic Manager profile configuration settings](./images/73.png)

4.11 **Add** a new endpoint and set the following parameters:

- Type: External endpoint
- Name: Cloud Integration EU
- Fully-qualified domain name (FQDN) or IP: SAP Cloud Integration runtime endpoint EU20 (without any protocol)
- Priority: 1

> Note: The SAP Cloud Integration runtime endpoint is the FQDN of the deployed REST API (without */http/ping*) that you have also mapped in the [previous step](#endpointmapping). 

![Cloud Integration EU](./images/74.png)

4.12 Open a new browser tab and navigate to the SAP BTP Cockpit, go to your first subaccount and open the **Instances and Subscriptions** view. Select the service with the service plan **integration-flow** and display the service key details. 

![Service Key details in SAP BTP Cockpit](./images/75.png)

> You have created the service instance and service key in [Step 2.24](#servicekey).

4.13 Open another browser tab and go to <http://base64encode.org>. Encode the **clientid** and **clientsecret** from the service key (see previous step) in the following format: 

```
<clientid>:<clientsecret>
```

> Example: sb-50162a35-56d0-4c06-adb0-3f315df3b0c3!b2657|it-rt-xyz34567!b196:af36f2ea-561a-44a3-977d-831f8ed9d129$Ta8rQN1LMzY9l9SvowftrpclBRqHNGJDvaX07vxyz123

![Encoding clientid and clientsecret via base64encode.org](./images/76.png)


4.14 Copy the encoded information to your clipboard. 

4.15 Go back to the browser tab, in that you have started to define one of the endpoints for the Azure Traffic Manager profile. Provide the authorization information as **Custom Header Settings** in the following format: 

```
Authorization:Basic <encoded clientid:clientsecret>
```

> Example: Authorization:Basic c2ItNTAxNjJhMzUtNTZkMC00YzA2LWFkYjAtM2YzMTVkZjNiMGMzIWIyNjU3fGl0LXJ0LW1234WQ2ZWQydHJpYWwhYjE5NjphZjM2ZjJlYS01NjFhLTQ0YTMtOTc3ZC04MzFmOGVkOWQxMjkkVGE4clFOMUxNelk5bDlTdm93ZnRycGNsQlJxSE5HSkR2YVgwN3Zja1pt1234

![Add Authorization details as Custom Header Settings](./images/77.png)

> Note: This way Azure Traffic Manager can authenticate against SAP Cloud Integration and can call the REST API without getting an HTTP 403 response. Alternatively you can call the REST API anonymously (so that the messages from Azure Traffic Manager to monitor the endpoints aren't counted as actual handled messages) but then you need to change the [monitoring settings](#tm-configuration) accordingly. A HTTP 403 response would then reveal Azure Traffic Manager that the endpoint is available, a 5xx HTTP response that the endpoint is not available. 

4.16 Continue with **Add**. 

4.17 You have created the first endpoint in the Azure Traffic Manager profile. **IMPORTANT: Repeat the Steps 10-16 for the other SAP Cloud Integration endpoint(s) in the other SAP BTP region(s).**

4.18 Display **Overview** of your Azure Traffic Manager profile and copy the **DNS Name**. 

![DNS Name of Azure Traffic Manager profile](./images/78.png)

4.19 Go to to the **DNS Zone** of your domain. 

![DNS Zone search using Azure Portal](./images/79.png)
![Select domain in Azure Portal](./images/80.png)

4.20 Create a record set for the subdomain that [you have mapped to the SAP Cloud Integration runtime endpoint](#endpointmapping): 

- Name: subdomain that you have mapped to the SAP Cloud Integration runtime endpoint
- Type: CNAME
- Alias Record Set: No
- TTL: 1 Second (depending on your requirements, how fast a failover should be executed)
- Alias: DNS Name of the Azure Traffic Manager profile that you have copied in Step 18 - without *http://*(e.g. cloudintegration-failover.trafficmanager.net)

![Select domain in Azure Portal](./images/81.png)

Congratulations. You have created an Azure Traffic Manager profile that detects which tenant should handle the messages based on a monitoring endpoint you have deployed (REST API in both SAP Cloud Integration tenants) in one of the previous steps. All requests sent to the mapped route in Cloud Foundry (cloudintegration.example.com) are going to the Azure Traffic Manager profile because of the CNAME record set in the DNS Zone of the domain. Azure Traffic Manager then decides on the priority setting which tenant should handle the request. All of this happens on DNS level. (If you want to use the Azure Traffic Manager for other scenarios like loadbalancing, reducing latency or others - have a look at the [available routing methods](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-routing-methods).)

A DNS Lookup shows the resolution: 

![DNS Lookup](./images/82.png)

> As an alternative to **dig** you can also use **nslookup** on Windows. 

You should also see that Azure Traffic Manager indicates that both SAP Cloud Integration as online right now. 

![DNS Lookup](./images/83.png)

## Step 5 - Test Failover Scenario

In this step you will test the recently created Azure Traffic Manager profile.

In the initial situation, both tenants are online and your primary tenant (priority 1 in Azure Traffic Manager) will process the requests. Then you simulate a situation where the primary tenant is not available by undeploying the monitoring endpoint of the primary tenant. Thus, Azure Traffic Manager will no longer receive the expected response from the call (HTTP 200) and will consider the primary tenant as offline.

Depending on the Failover & DNS TTL settings in Azure Traffic Manager profile, the Secondary Tenant (Priority 2 in Azure Traffic Manager) will process your upcoming requests after a certain time. The sender is effectively unaware of the process in the background, as it sends the requests to a domain regardless of the reachable tenants in the background.

---

5.1 Make sure the monitoring endpoints of both SAP Cloud Integration tenants are deployed. Then, go to the Azure Portal and look at the Traffic Manager profile. You should see that both tenants are considered as online. 

![Azure Traffic Manager profile endpoint status](./images/84.png)

5.2 Open a new terminal on your machine and call the SAP Cloud Integration REST API (*/http/ping*) that you have deployed for both SAP Cloud Integration tenants but this time with your domain. 

```console
curl cloudintegration.example.com/http/ping -u 'firstname.lastname@example.com:yourpassword'
```
![Custom Domain Call](./images/85.png)

As you can see, the primary tenant handles the request and sends back an HTTP body as defined in the SAP Cloud Integration REST API. 

> Note: Coincidentally (and for the sake of simplicity) the REST API you call in this step is the same as the Azure Traffic Manager profile uses to monitor the endpoints. 

> In this example we are not using the clientid and clientsecret (from the service key) for the particular SAP Cloud Integration tenants as they are tenant specific. Since the caller doesn't know which tenant is handling the request, a user in both subaccounts is necessary. You have assigned the needed Role Collection to your account in one of the [previous steps](#rolecollection-sender). That's the reason why you should use your personal BTP login credentials in this HTTP call. 

> Note: In case you're facing the error message "The filename, directory name, or volume label syntax is incorrect." in Windows, encode special characters like ' | ' in the username or password. 

5.3 Let's now simulate that the primary tenant is not available anymore. For testing purposes you can simply undeploy the REST API that acts as the monitoring endpoint for Azure Traffic Manager. That way, Azure Traffic Manager doesn't get a HTTP 200 Response from the REST API and considers the tenant as not available. 
Therefore, go to the **SAP Cloud Integration web interface** and select the said REST API. (**Monitor** option in the navigation area). Select **Undeploy** to undeploy the REST API from SAP Cloud Integration. You can deploy the API later again, as learned in one of the previous steps. 

![Undeploy REST API in SAP Cloud Integration web interface](./images/86.png)

5.4 Check the status of the endpoints in the Azure Traffic Manager profile. Depending on your failover settings in the Azure Traffic Manager profile configuration it takes a few moments until the primary tenant is considered as **Degraded**. 

![Endpoints monitoring Azure Traffic Manager profile](./images/87.png)

5.5 Go back to the terminal on your machine and call the REST API you have called in Step 2 again. 

```console
curl cloudintegration.example.com/http/ping -u 'firstname.lastname@example.com:yourpassword'
```

![Custom Domain Call](./images/88.png)

As you can see, the secondary tenant handles the request and sends back an HTTP body as defined in the SAP Cloud Integration REST API since Azure Traffic Manager considers the primary tenant as not reachable. 


Great job! You have configured the Azure Traffic Manager profile, provided the necessary endpoints as REST APIs of the SAP Cloud Integration tenants and succesfully integrated your own domain in this whole flow. You are done with the general setup for incoming HTTP requests. All other steps (like sychronizing Integration Content and security artifacts between the tenants) do not influence the behaviour you have defined until now. With this setup you can also use different routing methods Azure Traffic Manager to use it as a DNS Loadbalancer or route the traffic depending on the geographical location of the sender. 

## Setup SAP Cloud Transport Management - (Optional)

> This step is optional in some ways. The failover scenario also works without the transport management but is highly recommended for production scenarios!

In this step you will setup SAP Cloud Transport Management for the SAP Cloud Integration tenants you are using in the Azure Traffic Manager profile. 

All tenants that have been specified in the Azure Traffic Manager profile must be identical in their content. Otherwise, inconsistent processing of the Integration Flows/REST APIs may occur across tenants. Therefore, the productive tenants must also be at the same stand. In the following, you will configure SAP Cloud Transport Management so that you automatically transport from one SAP Cloud Integration tenant in the development environment to both productive SAP Cloud Integration tenants. 

For the sake of simplicity we use the SAP Cloud Integration tenant of the SAP BTP Trial as the development (DEV) Tenant. You can also use any other SAP Cloud Integration tenant as your source system for SAP Cloud Transport Management. 

A potential landscape could look like this: 

![Landscape](./images/89.png)

---

5.1 **(Optional)** If you don't have a third tenant available that acts as the development environment (from which you will transport to the other two productive tenants), [setup SAP Cloud Integration in the SAP BTP Trial](https://developers.sap.com/tutorials/cp-starter-isuite-onboard-subscribe.html). 

5.2 Open the SAP BTP Cockpit in the subaccount for the development (DEV) environment and look for **Content Agent** in the **Service Marketplace**. **Create** a service instance. 

> **IMPORTANT:** All the following artifacts are created in the subaccount of the development environment!

![Content Agent in the Service Marketplace](./images/90.png)

5.3 Keep everything as it is and provide **contentagent** as the service instance name. Continue with **Create**.

![Content Agent: Service instance creation details](./images/91.png)

5.4 Select **View Instance** to open the details for the created service instance. 

5.5 **Create a Service Key**. 

![Content Agent: Service instance creation details](./images/92.png)

5.6 Provide **contentagent_key** as the **Service Key Name** and continue with **Create**. 

5.7 Search for **Process Integration Runtime** in the **Service Marketplace** and create an instance. 

5.8 Choose **api** as the service plan and **cloudintegration_api** as the service instance name. Continue with **Next**. 

![Process Integration runtime: Service instance creation details](./images/93.png)

5.9  Provide the following **JSON** as service instance parameters and continue with **Create**. 

```json
{
    "roles": ["WorkspacePackagesTransport"]
}
```

![Process Integration runtime: Service instance creation JSON parameter](./images/94.png)

5.10 Select **View Instance** to open the details for the created service instance. 

5.11 **Create a Service Key**.

![Process Integration runtime: Service key creation](./images/95.png)

5.12 Provide **cloudintegration_apikey** as the **Service Key Name** and continue with **Create**. 

5.13 Search for **Cloud Transport Management** in the **Service Marketplace** and create an instance. 

![Cloud Transport management: Subscription creation](./images/96.png)

5.14 Select **Standard** as plan (type **Subscription**) and continue with **Create**. 

![Cloud Transport management: Subscription details](./images/97.png)

5.15 Additionally, Create a Service Instance of **Cloud Transport Management** for the Service Plan **standard**. 

![Cloud Transport management: Service instance creation](./images/98.png)

5.16 Make sure you are using the **standard** plan (type **Instance**) and provide **cloudtm** as the service instance name. 

![Cloud Transport management: Service instance creation details](./images/99.png)

5.17 Continue with **Create**. 

5.18 Select **Destinations** in the navigation area and create a **New Destination**. The Destination should be based on a **Service Instance** (select the tab) not on a blank template. 

![Content Assembly Destination creation](./images/100.png)

5.19 Select **contentagent** as the service instance and provide **ContentAssemblyService** (needs to be exactly this name, case-sensitive!). 

> **Important**: Make sure the destination is called exactly **ContentAssemblyService** otherwise SAP Cloud Integration won't recognize this destination. 

![Content Assembly Destination creation detail](./images/101.png)

5.20 Continue with **Next**. 

> the OAuth2 information from the service key of the selected service instance will now be loaded into the destination details. 

5.21 **Save** the Destination. 

![Saving the destination](./images/102.png)

5.22 Display the service key information of the **cloudintegration_api** service instance. 

![cloudintegration_api service details](./images/103.png)

5.23 Copy the values of **clientid**, **clientsecret** and **url** of the service key details. 

![cloudintegration_api URL](./images/104.png)

5.24 Open a new browser tab and create a **new Destination**. 

> a new browser tab so you can later on simply copy&paste the values of service key (step 23)

![New Destination](./images/105.png)

5.25 Provide the following details: 

  - **Name**: CloudIntegration
  - **Type**: HTTP
  - **Description**: Source Tenant SAP Cloud Integration
  - **URL**: `<url from step23>/api/1.0/transportmodule/Transport`
      (e.g.: https://e2ed6ed2trial.it-cpitrial03.cfapps.ap21.hana.ondemand.com/api/1.0/transportmodule/Transport)
  - **Proxy Type**: Internet
  - **Authentication**: Oauth2ClientCredentials
  - **Token Service URL**: `<token url from step23>`
      (e.g. https://e2ed6ed2trial.authentication.ap21.hana.ondemand.com/oauth/token)
  - **Client ID**: `<clientid from step23>`
  - **Client Secret**: `<clientsecret from step23>`

  ![New Destination details](./images/106.png)

5.26 **Save** the destination. 

5.27 Create a **new Destination**. 

5.28 Select **Service Instance** and select **cloudtm** (The Cloud Transport Management service instance), the name of destination does have to be **TransportManagementService**. 

> **Important**: The destination name is canse-sensitive and needs to follow the naming convention. 

![SAP Cloud Transport Management Destination creation](./images/107.png)

5.29 Continue with **Next** to fetch the service key information. 

5.30 Add a **New Property**: 

sourceSystemId=DEV

![sourceSystemId as new property for the destination](./images/108.png)
> make sure that this ID matches exactly the Node name of the source environment in SAP Cloud Transport Management. 

5.31 Continue with **Save**. 

5.32 Create another Destination (still in the subaccount of the development environment): 

- **Name**: CloudIntegration EU
- **Type**: HTTP
- **Description**: Cloud Integration EU - Production
- **URL**: `https://deploy-service.cfapps.<region>.hana.ondemand.com/slprot/<OrgNameOfTarget>/<SpaceNameOfTarget>/slp`
    e.g.: https://deploy-service.cfapps.eu20.hana.ondemand.com/slprot/Org%20with%20Spaces_cloudintegration-eu/dev/slp
- **ProxyType**: Internet
- **Authentication**: BasicAuthentication
- **User**: `<your username>`
- **Password** `<your password>`

**Replace <region> with the region of your  productive target subaccount, in this case it is eu20.** <br>
**Replace <OrgNameOfTarget> and <SpaceNameOfTarget> with the Cloud Foundry information of your productive target subaccount**. 

**Important: If the URL contains spaces, because your Cloud Foundry org or space contains spaces, replace the spaces with the URL escape character %20**

![Create Destination for productive target subaccount](./images/109.png)

> More information about Transport Destinations on [help.sap.com](https://help.sap.com/viewer/7f7160ec0d8546c6b3eab72fb5ad6fd8/Cloud/en-US/c9905c142cf14aea86fe2451434faed9.html)

5.33 **Save** the destination. 

5.34 Check the connection. You should get the following response:

![Check Connection for new Destination](./images/110.png)

5.35 Create another destination for the other productive target subaccount - similar to what you have done in step 32. 

- **Name**: CloudIntegration US
- **Type**: HTTP
- **Description**: Cloud Integration US - Production
- **URL**: `https://deploy-service.cfapps.<region>.hana.ondemand.com/slprot/<OrgNameOfTarget>/<SpaceNameOfTarget>/slp`
    e.g.: https://deploy-service.cfapps.us20.hana.ondemand.com/slprot/Org%20with%20Spaces_cloudintegration-us/dev/slp
- **ProxyType**: Internet
- **Authentication**: BasicAuthentication
- **User**: `<your username>`
- **Password** `<your password>`

**Replace <region> with the region of your  productive target subaccount, in this case it is us20.**
**Replace <OrgNameOfTarget> and <SpaceNameOfTarget> with the Cloud Foundry information of your productive target subaccount**. 

**Important: If the URL contains spaces, because your Cloud Foundry org or space contains spaces, replace the spaces with the URL escape character %20**

![Check Connection for new Destination](./images/111.png)

5.36 Check the connection. You should get the following response:

![Check Connection for new Destination](./images/112.png)

5.37 Create a new Role Collection **CloudIntegrationTM** in the development subaccount to enable Transport Management in the SAP Cloud Integration development tenant: 

![Check Connection for new Destination](./images/113.png)

5.38 Select the created Role Collection from the list of all Role Collections. 

5.39 Select **Edit** and add the following roles: 

- **AuthGroup_Admdinistrator**
- **WorkspacePackagesTransport**

5.40 Assign the Role Collection to your user and **Save**. 

![Role Collection for SAP Cloud TM](./images/114.png)

5.41 Creat another Role Collection called **CloudTransportManagement**. 

5.42 Select the created Role Collection from the list of all Role Collections and click on **Edit**.

5.43 Add all roles of the application identifier beginning with **alm-ts**. 

![Role Collection for SAP Cloud TM](./images/115.png)

> This is not a best practice to add all existing roles into a single Role Collection - this is only for the sake of simplicity in this exercise. 

5.44 Assign the Role Collection to your user and **Save**. 

![Role Collection for SAP Cloud TM](./images/116.png)

5.45 Open the web interface of SAP Cloud Integration the development environment and select **Settings** in the navigation area. 

5.46 Open the **Transport** Tab and select **Edit**. 

![Role Collection for SAP Cloud TM](./images/117.png)

5.47 Change the **Transport Mode** to **Transport Management Service**. 

5.48 **Save** the changes. 

5.49 Go to **Instances and Subscriptions** and open **Cloud Transport Management**. 

![Open Cloud Transport Management](./images/118.png)

5.50 Create the source Transport Node (development environment).

- **Name:** DEV
- **Description:** SAP Cloud Integration development Tenant
- **Allow Upload to Node**: Yes

Keep everything else as it is. 

![Open Cloud Transport Management](./images/119.png)

5.51 Continue with **OK**. 

5.52 Go back to the **Transport** configuration in SAP Cloud Integration and select **Check Configuration**. 

> The Configuration checks if the CloudIntegration as well as the TransportManagementService destination is reachable. Additionally, if the sourceSystemId (property of the TransportManagementService destination) is defined as a Transport Node (*with Allow Upload to Node*) in SAP Cloud Transport Management. 

![Open Cloud Transport Management](./images/120.png)

5.53 Go back to **SAP Cloud Transport Management** and create a **Transport Route** for the primary productive SAP Cloud Integration tenant: 

- **Name:** PROD_EU
- **Description:** SAP Cloud Integration productive tenant - EU
- **Allow Upload to Node:** Yes
- **Forward Mode:**: Auto
- **Content-Type:** Multi-Target Application
- **Destination:** CloudIntegrationEU

![Open Cloud Transport Management](./images/121.png)

5.54 Create another **Transport Route** for the secondary productive SAP Cloud Integration tenant: 

- **Name:** PROD_US
- **Description:** SAP Cloud Integration productive tenant - US
- **Allow Upload to Node:** Yes
- **Forward Mode:** Auto
- **Content-Type:** Multi-Target Application
- **Destination:** CloudIntegrationUS

![Open Cloud Transport Management](./images/122.png)

5.55 Create Transporte Routes from DEV to both prods seperately

5.56 Go to **Transport Routes** in the navigation area and **create** a new transport route. 

![Create new transport route](./images/123.png)

5.57 Configure the Transport Route as follows: 

- **Name:** DEV-PRIMARY
- **Description:** From DEV to Primary Tenant (EU)
- **Choose a source Node:** DEV
- **Choose a target Node:** PROD_EU

![Create new transport route](./images/124.png)

5.58 Continue with **OK**. 

5.59 Creater another Transport Route and configure it as follows: 

- **Name:** PRIMARY-SECONDARY
- **Description:** From Primary Tenant (EU) to Secondary Tenant (US)
- **Choose a source Node:** PROD_EU
- **Choose a target Node:** PROD_US

5.60 Continue with **OK**. 

You should now have all the needed transport routes to keep your productive tenants in synch. 
![Overview transport routes](./images/125.png)

5.61 Go to the SAP Cloud Integration web interface of your **development** environment. 

5.62 Select **Design** in the navigation area and choose an Integration Package that you would like to transport. 
![Design area SAP Cloud integration](./images/126.png)

> If you don't have an Integration Package yet, feel free to use one of the [previous steps](#download)

5.63 **Transport** the whole package and provide a short description. 

> Go to the **artifacts** tab and make sure no artifacts are in draft version. If that's the case, open the artifcats in the SAP Cloud Integration editor an **Save as Version**. 

> Note: You can also transport individual artifacts via the Actions button next to the version number. 

![Transport the content package](./images/127.png)
![Transport the content package](./images/128.png)

5.64 Go back **SAP Cloud Transport Management** and go to **Transport Nodes**. 

5.65 Select **PROD_EU**. 

You should now see the Transport Request that you have previously created SAP Cloud Integration development environment appearing in the import queue. 

![Transport the content package](./images/129.png)
![Transport Request created from SAP Cloud Integration](./images/130.png)

5.66 **Import All** Transport Requests. 

> Alternatively select requests that you want to transport and use **Import Selected**. 

![Import All Requests in SAP Cloud Transport Management](./images/131.png)

5.67 Check the Transport **Status** or **display the logs** for this transport request in case of errors.  

![Transport Request Status or Logs](./images/132.png)

5.68 Check the Primary SAP Cloud Integration Tenant if the Integration Package was imported. 

![Imported Content Package](./images/133.png)

5.69 Since you have already imported the Tranport Request into the primary productive tenant, go back to SAP Cloud Transport Management and go to the **PROD_US Transport Node**. 

![Transport Request from PROD_EU](./images/134.png)

5.70 Import the Transport Request that was recently imported to the PROD_EU Transport Node. 

5.71 Check the Transport **Status** or **display the logs** for this transport request in case of errors.  

5.72 Check the secondary SAP Cloud Integration Tenant if the Integration Package was imported. 

![Imported Content Package](./images/135.png)

5.73 Go back to SAP Cloud Transport Management and open the **PROD_EU Transport Node**. 

5.74 Click on the **calendar icon** to schedule the Transport Request import process. Schedule the import for every hour. 

![Imported Content Package](./images/136.png)

5.75 Repeat the import scheduling for the **PROD_US Transport Node**. 

Good Job! You have set SAP Cloud Transport Management for SAP Cloud Integration packages. You have now full control over your transports using SAP Cloud Transport Management. With the scheduled import of Transport Requests both into the primary SAP Cloud Integration tenant as well as to the secondary SAP Cloud Integration tenant, your tenants should now always be in synch without manual effort. 








