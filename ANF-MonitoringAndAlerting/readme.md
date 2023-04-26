
##  **Deploy** Custom Azure NetApp Files Monitoring and Alerting
**The current limitations with Azure NetApp Files in the Azure Portal is the lack of Insights workbooks and Diagnostic Logging on the ANF resource. The solution provided in the deployment below, will create a custom log table in Log Analytics, and also an Azure Insights Workbook to visualize and monitor the health of all ANF resources in a subscription. There are also alerts for low storage and no snapshots that can be triggered from the automation runbook**

#### **Summary of Steps**
TLDR - Brief Steps for Deployment:
 - Deploy this solution in the same Subscription as your Azure NetApp Files volumes. 
 - Create a New Resource Group - Example "RG-PRD-ANF-CustomLogging
 - **Do Not Change the Log Analytics Workspace Name** - This will break the Workbook paramaters and query.
 - Once The Deployment Starts - Go add the Managed Identity to "Reader" permissions on the Subscription of the Resource Group. Follow Instructions.
 - The runbook should automatically run on a schedule every 3 hours and populate the Workbook. If not make sure to follow these steps exactly as written.
 - Deployment will take aproximatly 5 minutes to complete.

**Deploy ANF Monitoring and Alerting**:  
**ATTENTION - Create a New Azure Resource Group During the Deployment**

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbsonnek%2FPublic%2Fmain%2FANF-MonitoringAndAlerting%2FARMDeploy.json)


## Instructions After Deployment
**[Follow These Instructions After the Deployment](https://github.com/bsonnek/Public/blob/main/ANF-MonitoringAndAlerting/Instructions.md)**

### This is a custom Azure NetApp Files deployment script that will deploy 6 resources into an Resource Group. Please Create a new Resource Group during the deployment.
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
 - Azure Monitor Workbook ( Wait 24 hours before the "Custom Logs" Tab starts Showing results)
	 - This will be used to visualize the data from the Custom log Table and Azure Monitor Metrics of ANF.
	 - You can pin this workbook to an Azure dashboard to make it easy to access later.


#### When the deployment is complete you will find 6 resources in the new Resource Group:

![image](https://user-images.githubusercontent.com/10324197/226236789-d7980477-ba85-44bb-a469-8e9327869bb7.png)

## ANF Custom Workbook - Screenshot Examples from Workbook

### Overview of the environment using Azure Monitor Metrics and Graph data.

![image](https://user-images.githubusercontent.com/10324197/226236184-6713c0ee-a5ed-4361-836a-18766d93e584.png)

### Details from the Custom Log Table created by the PowerShell runbook.

![image](https://user-images.githubusercontent.com/10324197/226235878-e5dcede9-036e-4a6e-a7d1-c0f67194977e.png)

### Additional details from Azure Monitor Metrics

![image](https://user-images.githubusercontent.com/10324197/226236611-7aad9c52-504c-4d4b-b61b-a16292b4f457.png)
