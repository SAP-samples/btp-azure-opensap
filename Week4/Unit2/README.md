


This exercise is part of the openSAP course [Building applications on SAP Business Technology Platform with Microsoft services](https://open.sap.com/courses/btpma1) - there you will find more information and context. 

# Setup Azure Data Explorer instance and load data 

In this exercise we will setup Azure Data Explorer (ADX) and import sample data. ADX will later on be connected to SAP HANA Cloud and the data surfaced in SAP Analytics Cloud. 

## Problems
> If you have any issues with the exercises, don't hesitate to open a question in the openSAP Discussion forum for this course. Provide the exact step number: "Week4Unit2, Step 1.1: Command cannot be executed. My expected result was [...], my actual result was [...]". Logs, etc. are always highly appreciated. 
 ![OpenSAP Discussion](../../images/opensap-forum.png)

## Step 1 - Login to Azure Portal and Create an Azure Data Explorer cluster

Creating an Azure Data Explorer Cluster can be done via the UI using the Azure Portal or a command line interface. In the next steps we will use the Azure Portal. For this we are using the Azure Admin user created in [Week 1, Unit 3](../../Week1/Unit3/README.md) )

**If you have not yet created a user in the Azure Portal, please follow the steps outlined in [Week 1, Unit 3](../../Week1/Unit3/README.md) and continue with Step 1.1 afterwards.**

---


1.1 Open [http://portal.azure.com](http://portal.azure.com) and log on with your Azure user.
     ![Azure Portal Login](./images/01-PortalLogin.jpg)

1.2 Click on the **+ Create a resource** button in the upper-left corner of the portal.
     ![Create a resource](./images/02-CreateResource.png)

1.3 Search for **Azure Data Explorer** and select the respective item from the search recommendations.
     ![Search Azure Data Explorer](./images/03-AzureDataExplorer.jpg)

1.4 Select Azure Data Explorer from the result list.

1.5 On the Azure Data Explorer **Create screen**, click on **Create**.
    ![Create Azure Data Explorer](./images/03-AzureDataExplorer-Create.jpg)

1.6 On the **Create an Azure Data Explorer Cluster** screen make sure that your correct **Azure Subscription** is selected. 

- For the Resource Group, click on **Create new** and enter the Name for the new Resource Group, **openSAPWeek4-RG** and click on OK
    ![Create Resource Group](./images/04-AzureDataExplorer-RG.jpg)

1.7 Fill out the remaining properties. For the **cluster name**, make sure you create a unique name, e.g. opensapclustermyname. Cluster names must begin with a letter and contain lowercase alphanumeric characters. Try an abreviation or add a number in case your desired name is already taken. For the **Azure region** select a **region close to you** and for the **Workload** select **Dev/Test**.

1.8 Deselect all Availability Zones. 

![Create Resource Group](./images/no-avail-zones.png)

Then click on **Review + Create**.

![Select properties](./images/05-AzureDataExplorer-clustername.jpg)

1.7 Once the properties have been validated you can click on **Create** and start the creation of the cluster. The creation can take a few minutes. 
![Create cluster](./images/06-AzureDataExplorer-review.jpg)

The creation of the cluster can take several minutes (5-10mins).


## Step 2 - Create Database in Azure Data Explorer

In order to load data into the Azure Data Explorer Cluster we need to create a database first. 

---

2.1. Once the deployment from Step 1.7 is done, you can click on **Go to resource** to jump directly to the Azure resource. 

![Go to Resource](./images/07-GotoResource.jpg)

**Note**: In case you missed this step you can also search for the clustername by entering the name from Step 1.6 in the Azure Portal search box:

![Search for Azure Data Explorer resourse](./images/08-SearchResource.jpg) 
    
2.2. On the Overview tab, click on **Create**. 

![Create database](./images/09-CreateDatabase.png) 

2.3. Enter **employeedb** as the name for the database and click on **Create**. 

![Enter Database name](./images/10-DBName.png)

2.4. Once the database is created, the Overview page is displayed again. Make sure to **note down/copy** the URI of your Azure Data Explorer Cluster. Click on the **Copy** icon to retrieve the URI, e.g. https://opensapclusterhbr1.northeurope.kusto.windows.net.

![Copy URI](./images/11-RememberURI.jpg)


2.5 As in a later Unit you will configure the database access from SAP HANA Cloud using your **Microsoft365 Developer Account** user, please ensure that also this user has access to your recently created database. 

> **Reminder**: If you followed the previous units, by now you should have two different users in your Azure Active Directory. 
>* The admin user which was used to create the Azure account (see Step 1 of [Week 1, Unit 3](../../Week1/Unit3/README.md))
>* The user of your Microsoft365 Developer Account (see Step 4 of [Week 2, Unit 1](../../Week2/Unit1/README.md))


Please follow the steps below to give your **Microsoft365 Developer Account user** access to the database. By default only the user who created to database should have access to it (which is your Azure admin user).

* Navigate to the **Query** menu of your Azure Data Explorer cluster
* Select **employeedb**
* Copy the following **query** and replace the placeholders  with the email address of your **Microsoft365 Developer Account** user!

    ```
    .add database employeedb users ('aaduser=<YOUR_USER>@<YOUR_DOMAIN>.onmicrosoft.com')  
    ```

* **Run** the query.

![Add database user - query](./images/add_databaseuser_query.png)

## Step 3 - Import data

In order to simplify the import of data, a CSV file with related sample data is already available in a central Azure Blob storage. You can just access this blob storage to import the data into your database. 

---

3.1 From the Overview screen click on **Ingest**. If the button is disabled, please refresh the page to ensure the database from step 2.3 was successfully created.

> In case you are asked to log in, go on with your Azure user. 

![Ingest New Data](./images/12-IngestNewData.png)

3.2 Make sure that the cluster and database that you recently created is selected. Enter the table name **employee-sample-data** and click on **Next:Source**.

> **IMPORTANT**: In case you cannot select any cluster, have a look at the 

[troubleshooting](#troubleshooting) section

![Create table](./images/13-CreateTable.png)

3.3 Enter the URI https://opensapadxsampledata.blob.core.windows.net/samplefiles/employee-sample-data.csv?sp=r&st=2021-09-10T18:37:46Z&se=2022-02-05T03:37:46Z&spr=https&sv=2020-08-04&sr=b&sig=kb5Ggb7yo1HHzD8HGCxueUIYwUVHOl%2F24w9eiVcEEx0%3D for the Link to source URL and click on **Next:Schema**

![Link to source](./images/14-LinktoSource.png)

3.4 In the last screen you should see the sample data in the **Partial data preview**. Just click on **Next:Summary**.

![Ingest data](./images/15-Schema.png)

3.5 Once the data is ingested you should see a success message on the screen. 

![Finished Ingestions](./images/16-DataIngestionFinished.png) 

**IMPORTANT:** <a name="restartvm"></a>Stop your Azure Data Explorer Cluster when you don't need it. The Azure Data Explorer Cluster is otherwise unnecessarily consuming some of your free credits (in case you are using the Azure Free Trial subscription).

## Step 4 - Optional - Simple Kusto query

In order to test the data import, you can run a quick Kusto query.  

---

4.1  Select **Take 10** from the Quick query section.  

![Run Query](./images/quick-query.png)

You should get 10 records of the recently ingested data. 

![Run Query](./images/quick-query-result.png)

## Summary

**Good work!** You successfully finished the configuration of the Azure Data Explorer to be exposed to SAP Analytics Cloud later on.

</br>

## Troubleshooting

## No cluster visible in Azure Data Explorer

In case you do not have any clusters in the selection list in the Azure Data Explorer (like on the screenshot below), your user needs to be added to one of the databases manually. 

**Problem:**
![No cluster available](./images/no-cluster.png)

**Solution:**
* Navigate to the **Query** menu of your Azure Data Explorer cluster
* Select **employeedb**
* Copy the following **query** and replace the **aaduser** value with the email address you are logged in to your Azure account:

    ```
    .add database employeedb users ('aaduser=yourazureaccount@outlook.com') 
    ```

* **Run** the query.

![Add database user - query](./images/add_databaseuser_query.png)

The query result should look similarly to the following screenshot: 

![Add database user - query](./images/add_databaseuser_result.png)

Retry to to open the Azure Data Explorer. You should now see the cluster automatically selected and the database in the selection list. 

If the cluster is still not available in Azure Data Explorer, please add the respective **cluster connection** now manually. Therefor please click on **Add cluster connection** and provide the URI which you copied in **Step 2.4**.

![Add cluster connection](./images/add_cluster_connection.png)

Now you should see the cluster connection and the database which you created. 

![Cluster connection](./images/cluster_connection.png)

