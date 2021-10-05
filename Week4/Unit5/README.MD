
This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 

# Connecting SAP Analytics Cloud with SAP HANA Cloud


In this exercise we will setup connection between SAP Analytics Cloud (SAC) and the data surfaced in SAP Analytics Cloud story. 

## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week4Unit4, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](../../images/opensap-forum.png)
 
## Step 1 - Create Virtual Table (aka Remote Table) for ADX table in SAP HANA Cloud

1.1. Open remote connection
Open the remote connection we created in Unit 3 and locate the table in ADX created in Unit 2.

![LocateTable](./images/01-locate-table.png)

1.2. Create Virtual Table
Select the table and Click the button Create Remote Table

![CreateRemoteTable](./images/02-create-remote-table.png)

1.3. Save Virtual Table
Enter a name and click Create

![SaveRemoteTable](./images/03-remote-table-name.png)

1.4. Open Virtual Table
Click Tables in the left menu and locate the table created in the previous step. Search the table by name.

![OpenRemoteTable](./images/04-virtual-table.png)


