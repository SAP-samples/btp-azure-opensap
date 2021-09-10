


This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 

# Exercise : Setup Azure Data Explorer instance and load data 

In this exercise we will setup Azure Data Explorer, ADX and import sample data. ADX will late be connected to SAP HANA Cloud and the data surfaced in SAP Analytics Cloud. 

Example: 
[Week4 Unit2 - Title](Week3/Unit1/README.md#Step-1---Set-up-your-trial-account-for-SAP-Workflow-Management)

## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week4Unit2, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](./images/opensap-forum.png)

## Step 1 - Login to Azure Portal and Create an Azure Data Explorer cluster

Creating an Azure Data Explorer Cluster can be done via the UI using the Azure Portal or a command line interface. In the next steps we will use the Azure Portal. For this we are using the Azure Admin user created in Week 1 Unit 3 )

** If you have not yet created a user in the Azure Portal, please follow the steps outlined in Week 1 Unit 3 and continue with Step 1.1.


1.1. Login to on the Azure Portal 
Open [http://portal.azure.com](http://portal.azure.com) and log on with your Azure Portal admin user.
     ![Azure Portal Login](./images/01-PortalLogin.jpg)

1.2. Create a Resource
Click on the "+ Create a resource" button in the upper-left corner of the portal.
     ![Create a resource](./images/02-CreateResource.jpg)

1.3. Search for Azure Data Explorer
In the Text-Searchbox type in "Azure Data Explorer" and select the found item.
     ![Search Azure Data Explorer](./images/03-AzureDataExplorer.jpg)

1.4. Create Azure Data Explorer
On the Azure Data Explorer Create screen, click on create
![Create Azure Data Explorer](./images/03-AzureDataExplorer-Create.jpg)

1.5. Select Subscription and Create Resource Group
On the "Create an Azure Data Explorer Cluster" screen make sure that your correct Azure Subscription is selected. For the Resource Group, click on "Create new" and enter the Name for the new Resource Group, openSAPWeek4-RG and click on OK
![Create Resource Group](./images/04-AzureDataExplorer-RG.jpg)

1.6. Provide Clustername and other properties
Fill out the remaining properties. For the cluster name, make sure you create a unique name, e.g. opensapclusterhbr. For the Azure region select a region close to you and for the Workload Dev/Test. Then click on "Review + Create"
![Select properties](./images/05-AzureDataExplorer-clustername.jpg)

1.7. Create the Cluster
Once the properties have been validated you can click on Create and start the creation of the cluster. Creation can take a few minutes. 
![Create cluster](./images/06-AzureDataExplorer-review.jpg)


[Week4 Unit2 - Step 1](Week4/Unit2/README.md#xxx)

## Step 2 - Create Database in Azure Data Explorer

In order to load data into the Azure Data Explorer Cluster we need to create a database first. 

2.1. Go to the Azure Data Explorer Resource 
Once the deployment from Step 1.7 is done, you can click on "Go to resource" to jump directly to the Azure resource. 
     ![Go to Resource](./images/07-GotoResource.jpg)

** Note: In case you missed this step you can also search for the clustername by entering the name from Step 1.6 in the Azure Portal search box:
    ![Search for Azure Data Explorer resourse](./images/08-SearchResource.jpg) 
    

2.2. Create Database
On the Overview tab, click on Create database
    ![Create database](./images/09-CreateDatabase.jpg) 

2.3. Enter Database name
Enter a name for the database, e.g. openSAP-database-hbr and click on Create. 
    ![Enter Database name](./images/10-DBName.jpg)

2.4. Note down the URI
Once the database is created the Overview page is displayed again. Make sure to note down / copy the URI to your Azure Data Explorer Cluster. Click on the Copy icon to retrieve the URI, e.g. https://opensapclusterhbr.northeurope.kusto.windows.net
    ![Copy URI](./images/11-RememberURI.jpg)

[Week4 Unit2 - Step 2](Week4/Unit2/README.md#xxx)

## Step 3 - Import data

In order to simplify the import of data, a CSV file with related sample data is already available in a central Azure Blob storage. You can just access this blob storage to import the data into your database. 

3.1. Click on Ingest data 
From the Overview screen click on "Ingest New data"
    ![Ingest New Data](./images/12-IngestNewData.jpg)

3.2. Create a table
Enter the table name employee-sample-data and click on "Next:Source"
    ![Crate table](./images/13-CreateTable.jpg)

3.3. Import from Blob
Enter the URI https://opensapadxsampledata.blob.core.windows.net/samplefiles/employee-sample-data.csv?sp=r&st=2021-09-10T18:37:46Z&se=2022-02-05T03:37:46Z&spr=https&sv=2020-08-04&sr=b&sig=kb5Ggb7yo1HHzD8HGCxueUIYwUVHOl%2F24w9eiVcEEx0%3D for the Link to source URL and click on Next:Schema
    ![Link to source](./images/14-LinktoSource.jpg)

3.4. Ingest the data
In the last screen you should see the sample that in the Partial data preview. Just click on Next:Summary. 
    ![Ingest data](./images/15-Schema.jpg)

3.5. Finish the ingestion
Once the data is ingested you can see a success message on the screen. 
    ![Finished Ingestions](./images/16-DataIngestionFinished.jpg) 

[Week4 Unit2 - Step 3](Week4/Unit2/README.md#xxx)


## Step 4 - Optional - Simple Kusto query

In order to test the imported data, you can run a quick Kusto query.  

4.1. Click Query and execute a query 
Enter the query 
['employee-sample-data']
| take 10
and click on run
    ![Run Query](./images/17-RunQuery.jpg)


[Week4 Unit2 - Step 4](Week4/Unit2/README.md#xxx)



## Summary

With this you have imported sample data to the Azure Data Explorer. From here we can a quick query. 

Example: 
*Good work!
You successfully finished the configuration of the Azure Data Explorer to be exposed to SAP Analytics Cloud later on. 



