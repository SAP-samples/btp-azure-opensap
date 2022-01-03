This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 

# SAP HANA Cloud and SAP Analytics Cloud Overview

In this exercise we will setup SAP Analytics Cloud (SAC) and SAP HANA Cloud. SAC will be later connected to SAP HANA Cloud and the data surfaced in SAP Analytics Cloud story. 

## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week4Unit2, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](../../images/opensap-forum.png)

## Prerequisites

Make sure that you have done the following units in order to be able to finish this week: 

* [Week 1, Unit 2](../../Week1/Unit2/README.md)
* [Week 1, Unit 3](../../Week1/Unit3/README.md)
* [Week 2, Unit 1](../../Week2/Unit1/README.md)
 
## Step 1 - Setup SAP Analytics Cloud Trial Account

First, you need a SAP Analytics Cloud Trial account. That's what we do in this step. 

---

1.1 Open [https://www.sap.com/products/cloud-analytics/trial.html](https://www.sap.com/products/cloud-analytics/trial.html). 

1.2 Make sure you are logged in with your user that you have created/used in [Week 1, Unit 2](../../Week1/Unit2/README.md)

**IMPORTANT: In case you log in with a gmail.com/yahoo.com email address: Please create a new account with a different email address. The SAP Analytics Cloud trial is only enabled for users with business email accounts.** 

![Registration](./images/00-login.png)

> In case you have registered with a new mail address, please make sure that you check your inbox in order to finish the verification process. 

1.2 Select **Start your free trial**. 

1.3. You'll receive an activation mail. Select **Activate Account**. 

![Activation Mail](./images/03-sac-activation.png)
 
1.4 Set a **new password** for your SAP Analytics Cloud Trial account. 

![Set Password for new SAC account](./images/04-set-password.png)

1.5 **Continue** to access your SAP Analytics Cloud Trial. 

![Continue to SAC](./images/05-continue.png)

 ## Step 2 - Setup SAP HANA Cloud

SAP HANA Cloud will play a substantial role in this week's content. To be prepared for the next exercises, you'll set up a SAP HANA Cloud instance in your already existing SAP BTP Trial account. 

---

**IMPORTANT: Please make sure that you have gone through the exercises in the [prerequisites](#prerequisites) section.**

2.1 Go to your [SAP BTP Trial Cockpit](https://hanatrial.ondemand.com)

2.2 Select **Go To Your Trial Account**. 

2.3 **Create** a new **Subaccount**. 

![New Subaccount Button](./images/06_newsubaccount.png)

2.4 Provide **hanacloud** as the name of your new subaccount. Choose **US East (VA) cf-us10** for the region. Keep everything else as it is. 

2.5 Continue with **Create**. Your new subaccount gets created now. 

> SAP HANA Cloud trial is currently only available on an SAP BTP trial region on AWS. To run these exercises, please create a new subaccount on the new SAP BTP trial region - but technically this makes no difference for the exercises.  Of course, in production accounts SAP HANA Cloud is available on multiple Microsoft Azure Regions as well. For an overview please go to the [Discovery Center](https://discovery-center.cloud.sap/serviceCatalog/sap-hana-cloud?region=all&tab=service_plan). 

![Subaccount details](./images/07-subaccountdetails.png)

2.6 Select the new subaccount once the subaccount provisioning has finished sucessfully. (When the **Onboarding** text disappears from the subaccount tile)

2.7 Navigate to **Entitlements** and select **Configure Entitlements**. 

![Navigate to Entitlements](./images/08-entitlements.png)

2.8 Select **Add Service Plans**. 

![Add Service Plans button](./images/09-add-service-plan.png)

2.9 Search for **HANA Cloud**, select the item from the result list and select all the available plans. Continue with **Add 3 Service plans**. 

> Not all of the service plans are actually needed for this exercise but it's easier if you want to continue with SAP HANA Cloud for other scenarios later on. 

![SAP HANA Cloud service plans](./images/10-serviceplandetails.png)

2.10 Double-check if the service plans were added to the entitlements list and **Save** your changes. 

![save SAP HANA Cloud service plans](./images/11-save-entitlements.png)

2.11 **Navigate to your subaccount** and **Enable Cloud Foundry**. 

![Enable Cloud Foundry](./images/12-enable-cf.png)

2.12 Keep everything as it is and **Create** the new Cloud Foundry environment instance. 

![New cloud foundry environment detail](./images/13-new-environment.png)

2.13 Select **Create Space** on the overview page of the subaccount to create a new **Cloud Foundry space**. 

![Create Cloud Foundry](./images/14-create-space.png)

2.14 Provide **hanaspace** as the space name and assign the available space roles to your user. Once created, select the new space which should be visible below the **Create Space** button which you recently clicked.

2.15 Navigate to **SAP HANA Cloud** in your Cloud Foundry space and select **Create > SAP HANA database**. 

![Create HANA database](./images/15-create-hana-database.png)

2.16 You will be asked to choose the identity provider which you want to use for authentication. Choose **Sign in with default identity provider** and you'll automatically be signed in since you are already authenticated in other tabs of your browser. 

![Choose Identity Provider](./images/16-default-idp.png)

2.17 Choose **SAP HANA Cloud, SAP HANA Database** when you are asked for the type of the SAP HANA Cloud instance. Then click on **Next Step** in the lower right of your screen.

![Choose Type of HANA Cloud instance](./images/17-type-hanadb.png)

2.18 Set **openSAP** as the SAP HANA Database instance name and provide a password for the DBADMIN user (Database administrator user). Accept all other default options and Create the HANA Database. 

> **IMPORTANT:** You are going to use the DBADMIN user throughout the next exercises, so make sure that you can remember the password. Better note it down and store it safely.

![Input Forms HANA Cloud detail](./images/18-hanacloud-details.png)

2.19 Click **Next Step** until you reach **Step 5** - **SAP HANA Database Advanced Settings**. Under **Allowed connections**, select **Allow all IP addressed** and click **Create Now**.

![Create HANA Cloud now without further input](./images/all_all_IP.png)

2.20 You are getting a summary of the SAP HANA Cloud instance details. Select **Create Instance**. 

2.21 Wait until the SAP HANA Cloud instance is in state **Running**. (refresh every now and then)

![SAP HANA Cloud Central - HANA creation started](./images/20-hana-creation-started.png)
![SAP HANA Cloud Central - HANA creation finished](./images/21-hana-creation-finished.png)

# Summary

Congrats, good job! You succesfully created your own SAP Analytics Cloud Trial and already instantiated an SAP HANA Cloud instance. Both of them are essential bits & pieces for the next units in order to visualize data from Azure Data Explorer in SAP Analytics Cloud.

