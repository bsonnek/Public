param location string = resourceGroup().location
param resourcegroupId string = resourceGroup().id
param parImageURL string = ''
param parPIMLink string = ''

// Support Workbook Variables
var supportOverviewContent = string(loadJsonContent('Module-Support/Workbooks/fileSupportOverview.json')) // Support Overview Workbook
var AVDfileContent = string(loadJsonContent('Module-Support/Workbooks/fileAzureVirtualDesktop.json')) // AVD Workbook
var alertsAndLogs= string(loadJsonContent('Module-Support/Workbooks/fileAlertLogs.json')) // Alerts and Logs Workbook
var AzureFilesMetrics= string(loadJsonContent('Module-Support/Workbooks/AzureFileMetrics.json')) // Alerts and Logs Workbook
var VMMetrics= string(loadJsonContent('Module-Support/Workbooks/fileVMMetricsWorkbook.json')) // Alerts and Logs Workbook
var ANFMetrics= string(loadJsonContent('Module-Support/Workbooks/fileANFMetrics.json')) // Alerts and Logs Workbook
var VMAppsAndServ= string(loadJsonContent('Module-Support/Workbooks/fileVMApplicationsAndServ.json')) // Alerts and Logs Workbook
var EnvironmentOver= string(loadJsonContent('Module-Support/Workbooks/fileEnvironmentOverview.json')) // Alerts and Logs Workbook
// Platform Workbook Variables
var VMAgentHealth= string(loadJsonContent('Module-Platform/Workbooks/VMAgentHealth.json')) // Alerts and Logs Workbook
var LogIngestionTrends= string(loadJsonContent('Module-Platform/Workbooks/LogIngestion.json')) // Alerts and Logs Workbook
var AutomationHealth= string(loadJsonContent('Module-Platform/Workbooks/AutomationHealth.json')) // Alerts and Logs Workbook
var ConfigurationReport= string(loadJsonContent('Module-Platform/Workbooks/ConfigurationHealth.json')) // Alerts and Logs Workbook
var LogCollectionCheck= string(loadJsonContent('Module-Platform/Workbooks/LogCollectionChecker.json')) // Alerts and Logs Workbook


// Support Dashboard Deployment
module supportDashModule './Module-Support/Dashboard.bicep' = {
  name: 'support-Dashboard'
  params: {
    location: location
    parImageURL: parImageURL
    parPIMLink: parPIMLink
  }
}

// Support Workbook Deployment
resource supportOverviewWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: 'dbfe15f8-1d39-4f29-97fc-19e95726c4ca'
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - Subscription Overview'
    serializedData: supportOverviewContent
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// AVD Workbook Deployment
resource AVDWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '577719bd-8974-42f2-b91b-9ab0a2b4f52f' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - Azure Virtual Desktop'   // Change Name of Workbook
    serializedData: AVDfileContent
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// Alerts And Logs Workbook Deployment
resource AlertsAndLogsWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '0ba13d04-018b-40fe-a72f-e65b4f69f042' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - Alerts and Logs'   // Change Name of Workbook
    serializedData: alertsAndLogs
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// Azure Files Metrics Workbook Deployment
resource AzureFilesMetricxsWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: 'd5575d3c-8cef-45df-8618-49a5e11fcb9c' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - Azure File Metrics'   // Change Name of Workbook
    serializedData: AzureFilesMetrics 
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// VM Metrics Workbook Deployment
resource VMMetricsWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: 'b3c5d681-3c06-4ba2-b22e-28e553d75bb4' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - VM Metrics Workbook'   // Change Name of Workbook
    serializedData: VMMetrics
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// ANF Metrics Workbook Deployment
resource ANFMetricsWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '7fd539cf-dcbe-4066-974c-77512222ed76' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - NetApp Files Workbook'   // Change Name of Workbook
    serializedData: ANFMetrics
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// VM Apps and Services Workbook Deployment
resource VMAppsAndServWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: 'a5a9b1b8-69f0-4ad1-8a55-d0ed9cbeb264' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - VM - Applications and Services'   // Change Name of Workbook
    serializedData: VMAppsAndServ
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// Environment Overview Workbook Deployment
resource EnvironmentOverWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '5d096f4e-8dcc-4d24-af9c-e91741498091' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Support - Environment Overview'   // Change Name of Workbook
    serializedData: EnvironmentOver
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}


////////////////////////////////////
// Platform Dashboard Deployment ///
////////////////////////////////////

// Platform Dashboard Deployment
module platformDashModule './Module-Platform/Dashboard.bicep' = {
  name: 'platform-Dashboard'
  params: {
    location: location
  }
}

// VM Agent Health Workbook Deployment
resource VMAgentHealthWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: 'e7b7e126-b788-4da5-bfb3-ebc0998a2536' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Platform - Agent Health Overview'   // Change Name of Workbook
    serializedData: VMAgentHealth
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// Log Ingestion Trends Workbook Deployment
resource LogIngestionWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '578b0f53-82d8-4c96-b3dd-02afacf01cc5' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Platform - Log Ingestion Workbook'   // Change Name of Workbook
    serializedData: LogIngestionTrends
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// Automation Health Workbook Deployment
resource AutomationHealthWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '2ca63c95-d20a-445f-99c6-e3cfa8a010e1' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Platform - Automation Health'   // Change Name of Workbook
    serializedData: AutomationHealth
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}


// Configuration Report Workbook Deployment
resource ConfigurationReportWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: '64eedfb4-8ed7-4aa2-925c-5c1a468b2024' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Platform - Subscription Configuration Report'   // Change Name of Workbook
    serializedData: ConfigurationReport
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}

// Log Collection Checker Workbook Deployment
resource LogCollectCheckWorkbook 'microsoft.insights/workbooks@2022-04-01' = {
  name: 'f19d94a3-2eff-47fd-b05a-bb9dc8126041' // Go to the Workbook Resource and copy the ID
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Platform - Log Collection Checker'   // Change Name of Workbook
    serializedData: LogCollectionCheck
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
}


output resourcegroupId string = resourcegroupId
