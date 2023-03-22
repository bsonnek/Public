
##  **Deploy** Custom Azure NetApp Files Monitoring and Alerting

**Deploy ANF Monitoring and Alerting**:  
**ATTENTION - Create a New Azure Resource Group During the Deployment**

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbsonnek%2FPublic%2Fmain%2FANF-MonitoringAndAlerting%2FARMDeploy.json)

### This is a custom Azure NetApp Files deployment script that will deploy 6 resources into an Resource Group. Create a new Resource Group during the deployment.
List of Az Resources and purpose:
 - Automation Account:
	 - Variables - Environment Variables used in the Runbook to Trigger Logic Apps and write logs to a custom table in Log Analytics Workspace.
	 - Runbook - 
		 - Cycle through all Azure NetApp Files and export the storage stats to the Log Analytics workspace custom table
		 - Alerts will be triggered if the storage usage is above 90% for 30 minutes
         - Alerts will be triggered if the Snapshots are older than 2 days
 - Logic Apps (2) - You will need to finalize the last step to trigger an email, teams chat, etc.. 
	 - LA-PRD-ANF-LowStorage - The Runbook will Invoke the API and Trigger this Logic App to alert
	 - LA-PRD-ANF-NoSnapshot - The Runbook will Invoke the API and Trigger this Logic App to alert
 - Log Analytics Workspace
	 - The Runbook will create a custom log table called "NetAppFilesStats_CL"
	 - The Azure Monitor Workbook will read the custom log table to visualize the data.
 - Azure Monitor Workbook
	 - This will be used to visualize the data from the Custom log Table and Azure Monitor Metrics of ANF.
	 - You can pin this workbook to an Azure dashboard to make it easy to access later.


#### When the deployment is complete you will find 6 resources in the new Resource Group:
![image](https://user-images.githubusercontent.com/10324197/226236789-d7980477-ba85-44bb-a469-8e9327869bb7.png)


# Instructions After Deployment
**[Follow These Instructions After the Deployment](https://github.com/bsonnek/Public/blob/main/ANF-MonitoringAndAlerting/Instructions.md)**


## ANF Custom Workbook - Screenshot Examples from Workbook

![image](https://user-images.githubusercontent.com/10324197/226236184-6713c0ee-a5ed-4361-836a-18766d93e584.png)

![image](https://user-images.githubusercontent.com/10324197/226235878-e5dcede9-036e-4a6e-a7d1-c0f67194977e.png)

![image](https://user-images.githubusercontent.com/10324197/226236611-7aad9c52-504c-4d4b-b61b-a16292b4f457.png)
