## VM-Agent-Identities-Extensions  Workbook

**Warning Most of these workbooks are built to be used in an Azure Lighthouse Environment.**

The importance of this workbook is to make sure agents are reporting and logging data to Log Analytics Workspaces. Withtout log data alerting and monitoring is not possible from Log Analytics data.


### Workbook Overview 
Track AMA and MMA Agent Health, VM Extenstions, and System and User assigned Managed Identites


### TAB - Overview
Overview tab shows Total VMs, MMA, and AMA agents.  Healthy and Unhealthy status set by paramaters in the workbook.

![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/1-Overview.png)


### TAB - Log Analytics Agent Overview

![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/2-LogAnalyticsAgent.png)

**Importance of VM running and if the Agent is reporting**
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/3-AMAOverview.png)



### TAB - Azure Monitor Agent Overview
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/4-AMA%20Agent%20Running.png)




### TAB - VM Extension
Monitor VM Extension Installation, Configuration, and Health
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/6-VMExtensionDetails.png)

![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/6-1-AMA-ExtensionDetails.png)




### TAB - Managed Identities
Customize this tab to track managed identites assigned to your VMs
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/VM-Agents-Identities-Extensions/Screenshots/\7-ManagedIdentities.png)


