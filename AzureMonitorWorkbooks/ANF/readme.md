## Azure NetApp Files - Custom Workbook

To Install this workbook - 
1. Create a new Azure Monitor Workbook.
2. Select the </> icons in the workbook 
3. Paste in the contents of this file [ANF_Public_Workbook-GalleryTemplate](.\ANF_Public_Workbook-GalleryTemplate.json)

C:\Github-localRepos\Public\AzureMonitorWorkbooks\ANF\ANF_Public_Workbook-GalleryTemplate.json
### Overview Tab
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/ANF/Screenshots/1-Overview-Tab.png)

### Storage Latency Tab
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/ANF/Screenshots/2-StorageLatency.png)

### Throughput Tab
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/ANF/Screenshots/3-ThroughputTab.png)

### Storage Consumed Tab
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/ANF/Screenshots/4-StorageConsumed.png)

### This Query is not included in this workbook:
This data is populated in a Custom Log Table - A Powershell runbook retrieves ANF details and logs to a custom table. 
This KQL query retrieves the results and displays them.
![image](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/ANF/Screenshots/5-CustomTab.png)

### This Powershell runbook can be scheduled to populate a custom table in Log Analytics workspace.
[ANF-Runbook](https://github.com/bsonnek/Public/blob/main/AzureMonitorWorkbooks/ANF/Screenshots/AzureFiles-CustomLogs.ps1)


