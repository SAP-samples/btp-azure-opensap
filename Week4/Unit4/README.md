
This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 

# Connecting SAP Analytics Cloud with SAP HANA Cloud


In this exercise we will setup connection between SAP Analytics Cloud (SAC) and SAP HANA Cloudn.In Unit 5 we will visualize ADX data in a SAP Analytics Cloud story. 

## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week4Unit4, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](../../images/opensap-forum.png)
 
## Step 1 - Setup new SAP HANA Connection

This section will walk you through the steps to be followed to setup up live connection between SAP Analytics Cloud and SAP HANA Cloud.

**IMPORTANT:** If you have not yet created a SAP Analytics Cloud trial account, please follow the steps outlined in Week 4 Unit 1 and continue with Step 1.1 afterwards.**

---

1.1. Create new connection
Logon to SAP Analytics Cloud using the credentials from [Week 4, Unit1](../Unit1/README.md). **Expand the side menu** and **click Connections** in the menu on the rightside. Then hit the **plus sign** on the top left side.

![NewConnection](./images/01-new-connection.png)


1.2. Select **SAP HANA** (Connect to Live Data). 

![NewHANACloud](./images/02-hana-connection.png)


1.3. Enter the credentials for SAP HANA Cloud and click OK.

  Connection Type : SAP HANA Cloud
  Host : <your HANA Cloud instance host name> (how to get the host name: [Week 4, Unit 3 - Step 7.4](../Unit3/README.md#hostname))
  Authentication Method : User Name and Password
  User Name : DBADMIN
  Password : <Password for DBADMIN>
  
  ![Credentials](./images/03-credentials.png)
  
  Now you have successfully setup a live Connection from SAP Analytics Cloud to SAP HANA Cloud. 
