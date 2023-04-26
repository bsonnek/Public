## Log Ingestion Cost Workbooks

** Warning Most of these workbooks are built to be used in an Azure Lighthouse Environment.

This workbook is used to analyze cost of log ingestion accross multiple subscriptions and show trends that will impact Azure spend.

The workbook has multiple tabs for drilling down into Log Analytic workspace tables to analyze events that are increasing ingestion cost.


### Overview Tab:
![image](https://github.com/bsonnek/Public/edit/main/AzureMonitorWorkbooks/Log-Ingestion/Screenshots/1-Overview.png)

![image](.\Screenshots\2-OverviewGraphs.png)


### Subscription Size:
![image](.\Screenshots\3-SubscriptionSizes.png)


### Log Type Size by Table
![image](.\Screenshots\4-LogTypeSizeByTable.png)


### Log Type Size by Subscription
Filter by Log Type  - The results will show all subscirptions filtered by the log type and display ingestion volume and Cost

![image](.\Screenshots\5-LogTypeSizeBySubscription.png)


### Other misc tabs specific to our environment

