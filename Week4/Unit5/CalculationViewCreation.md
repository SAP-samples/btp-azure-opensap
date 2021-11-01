 
 ## Create Calculation View and deploy it in SAP HANA Cloud
 
  1. In your business application studio, select menu View -> Find Command
  ![FindCommand](./images/bh1.png)
 
  2. Type "HANA Database Artifact" and select Create SAP HANA Database Artifact.
  ![HANAArtifact](./images/bh12.png)
  
  3. Select artifact type as "Calculation View" and enter artifact name "Employee_calculation_view".
   ![CreateCV](./images/bh2.png)
   
  4. Once the calculation view is created, select the calculation view and add "Projection" to the calculation view.
   ![AddProjection](./images/bh3.png)
   
  5. Select the projection and connect the projection to the Aggregation
   ![ConnectProjectionAggregation](./images/bh4.png)

  6. Select the Projection and click the Plus button to add data source
   ![AddSource](./images/bh5.png)
   
  7. Click the Services drop down and select "ups_opensap"
   ![Select UPS](./images/bh6.png)

  8. Type employee_view and click search. Once the Employee_view is listed, select it and click "Create Synonym". 
  Note: If you have not created view in the SAP HANA Cloud for your remote table, you can search and select your remote table "virtual-employee-sample-data" directly.

   ![SelectView](./images/bh7.png)
   
  9. Now click Finish button.
   ![ClickFinish](./images/bh8.png)
   
  10. Select projection and drag and drop "Salary" column to the output section. 
   Note : If you have selected remote table directly in step 8, you will see more columns.
   ![ProjectSalary](./images/bh9.png)
   
  11. Now select Aggregation and drag and drop "Salary" column to the output section.
   ![AggregateSalary](./images/bh10.png)
   
  12. Click deploy button (Rocket icon) next to the project workspace and deploy the calculation view.
   ![DeployWorkspace](./images/bh11.png)
   
   Now your calculcation view is successfully deployed to SAP HANA Cloud
  
