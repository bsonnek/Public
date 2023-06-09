param location string
param resourcegroupId string = resourceGroup().id
param parImageURL string = ''
param parPIMLink string = ''

resource supportDashModule 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: '41e2683d-faa2-47e3-8859-172a732edab0'
  location: location
  tags: {
    'hidden-title': 'Support Dashboard'
  }
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'UTC'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 2
              y: 0
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Pacific Standard Time (Mexico)'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 4
              y: 0
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Mountain Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 6
              y: 0
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Central Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 8
              y: 0
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Eastern Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 10
              y: 0
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'India Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 12
              y: 0
              colSpan: 10
              rowSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  value: null
                  isOptional: true
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/microsoft.insights/workbooks/5d096f4e-8dcc-4d24-af9c-e91741498091'
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'PinName'
                  value: 'Support - Environment Overview'
                  isOptional: true
                }
                {
                  name: 'StepSettings'
                  value: '{"version":"KqlItem/1.0","query":"desktopvirtualizationresources\\r\\n| where type == \\"microsoft.desktopvirtualization/hostpools/sessionhosts\\"\\r\\n| where properties[\'sessionHostHealthCheckResults\'][0][\'healthCheckResult\'] == \\"HealthCheckSucceeded\\"\\r\\n| summarize count() by id, name, location","size":1,"title":"Healthy Session Hosts","queryType":1,"resourceType":"microsoft.resourcegraph/resources","crossComponentResources":["value::all"],"visualization":"map","mapSettings":{"locInfo":"AzureLoc","locInfoColumn":"location","sizeSettings":"count_","sizeAggregation":"Sum","minSize":1,"maxSize":40,"defaultSize":1,"labelSettings":"location","legendMetric":"count_","legendAggregation":"Sum","itemColorSettings":null}}'
                  isOptional: true
                }
                {
                  name: 'ParameterValues'
                  value: {
                    Subscription: {
                      type: 6
                      value: [
                        'value:all'
                      ]
                      isPending: false
                      isWaiting: false
                      isFailed: false
                      isGlobal: false
                      labelValue: 'All'
                      displayName: 'Subscription'
                      specialValue: [
                        'value::all'
                      ]
                      formattedValue: 'All'
                    }
                    LogAnayltics: {
                      type: 5
                      value: [
                        'value:all'
                      ]
                      isPending: false
                      isWaiting: false
                      isFailed: false
                      isGlobal: false
                      labelValue: 'All'
                      displayName: 'Log Anayltics'
                      specialValue: [
                        'value::all'
                      ]
                      formattedValue: 'All'
                    }
                    TimeRange: {
                      type: 4
                      value: {
                        durationMs: 14400000
                      }
                      isPending: false
                      isWaiting: false
                      isFailed: false
                      isGlobal: false
                      labelValue: 'Last 4 hours'
                      displayName: 'TimeRange'
                      formattedValue: 'Last 4 hours'
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart'
              filters: {
                MsPortalFx_TimeRange: {
                  model: {
                    format: 'local'
                    granularity: 'auto'
                    relative: '4h'
                  }
                }
              }
            }
          }
          {
            position: {
              x: 0
              y: 2
              rowSpan: 1
              colSpan: 5
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '${parPIMLink}\r\n\r\n[Confluence Support Link](https://)'
                    title: ''
                    subtitle: ''
                    markdownSource: 1
                    markdownUri: null
                  }
                }
              }
            }
          }
          {
            position: {
              x: 5
              y: 2
              rowSpan: 1
              colSpan: 3
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: parImageURL
                    title: ''
                    subtitle: ''
                    markdownSource: 1
                  }
                }
              }
            }
          }
          {
            position: {
              x: 8
              y: 2
              colSpan: 4
              rowSpan: 3
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    subscriptions: 'all'
                    regions: 'all'
                    services: ''
                    resourceGroupId: 'all'
                    timeSpan: '5'
                    startTime: '2022-04-15T00:53:34.517Z'
                    endTime: '2022-04-18T00:53:34.517Z'
                    queryName: 'Health-Alerts-4-17'
                    queryId: '1aa615b7-cd7e-4b7e-b7c5-2c1752b6c80f'
                    loadFromCache: false
                    communicationType: 'serviceissue'
                    statusFilter: 'active'
                  }
                }
              ]
              type: 'Extension/Microsoft_Azure_Health/PartType/ServiceIssuesTilePart'
            }
          }
          {
            position: {
              x: 0
              y: 3
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/dbfe15f8-1d39-4f29-97fc-19e95726c4ca'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/dbfe15f8-1d39-4f29-97fc-19e95726c4ca'
                }
              }
              partHeader: {
                title: 'Subscription Overview'
                subtitle: 'All Resources in Subscription'
              }
            }
          }
          {
            position: {
              x: 2
              y: 3
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/577719bd-8974-42f2-b91b-9ab0a2b4f52f'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/577719bd-8974-42f2-b91b-9ab0a2b4f52f'
                }
              }
              partHeader: {
                title: 'Azure Virtual Desktop'
                subtitle: 'Start Here - AVD Health'
              }
            }
          }
          {
            position: {
              x: 4
              y: 3
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: []
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/0ba13d04-018b-40fe-a72f-e65b4f69f042'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/0ba13d04-018b-40fe-a72f-e65b4f69f042'
                }
              }
              partHeader: {
                title: 'Alerts and Logs'
                subtitle: 'Alerts and Log Workbook'
              }
            }
          }
          {
            position: {
              x: 6
              y: 3
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/d5575d3c-8cef-45df-8618-49a5e11fcb9c'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/d5575d3c-8cef-45df-8618-49a5e11fcb9c'
                }
              }
              partHeader: {
                title: 'Azure File Metrics'
                subtitle: 'Troubleshoot Azure File Storage'
              }
            }
          }
          {
            position: {
              x: 0
              y: 5
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/b3c5d681-3c06-4ba2-b22e-28e553d75bb4'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/b3c5d681-3c06-4ba2-b22e-28e553d75bb4'
                }
              }
              partHeader: {
                title: 'VM Metrics'
                subtitle: 'Virtual Machine Health'
              }
            }
          }
          {
          position: {
            x: 2
            y: 5
            colSpan: 2
            rowSpan: 2
          }
          metadata: {
            inputs: [
              {
                name: 'ComponentId'
                value: {
                  Name: 'Azure Monitor'
                  ResourceId: 'Azure Monitor'
                  LinkedApplicationType: -2
                }
              }
              {
                name: 'ResourceIds'
                value: [
                  'Azure Monitor'
                ]
                isOptional: true
              }
              {
                name: 'Type'
                value: 'workbook'
                isOptional: true
              }
              {
                name: 'TimeContext'
                isOptional: true
              }
              {
                name: 'ConfigurationId'
                value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/7fd539cf-dcbe-4066-974c-77512222ed76'
                isOptional: true
              }
              {
                name: 'ViewerMode'
                value: false
                isOptional: true
              }
              {
                name: 'GalleryResourceType'
                value: 'Azure Monitor'
                isOptional: true
              }
              {
                name: 'NotebookParams'
                isOptional: true
              }
              {
                name: 'Location'
                value: location
                isOptional: true
              }
              {
                name: 'Version'
                value: '1.0'
                isOptional: true
              }
            ]
            type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
            viewState: {
              content: {
                configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/7fd539cf-dcbe-4066-974c-77512222ed76'
              }
            }
            partHeader: {
              title: 'ANF Metrics'
              subtitle: 'Azure NetApp Files Metrics'
            }
          }
        }
          {
            position: {
              x: 4
              y: 5
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: ''
                    ResourceGroup: 'RG-PRD-EU-Support-Dashboards'
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/a5a9b1b8-69f0-4ad1-8a55-d0ed9cbeb264'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  value: ''
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/a5a9b1b8-69f0-4ad1-8a55-d0ed9cbeb264'
                }
              }
              partHeader: {
                title: 'VM Apps and Services'
                subtitle: 'Status of Apps and Services'
              }
            }
          }
          {
            position: {
              x: 6
              y: 5
              colSpan: 2
              rowSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: 'Azure Monitor'
                    ResourceId: 'Azure Monitor'
                    LinkedApplicationType: -2
                  }
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/5d096f4e-8dcc-4d24-af9c-e91741498091'
                  isOptional: true
                }
                {
                  name: 'ViewerMode'
                  value: false
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'NotebookParams'
                  value: '{"Subscription":["value::all"],"LogAnayltics":["value::all"],"TimeRange":{"durationMs":14400000},"selectedTab":"AVDHostHealth"}'
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '1.0'
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/NotebookPinnedPart'
              viewState: {
                content: {
                  configurationId: '${resourcegroupId}/providers/Microsoft.Insights/workbooks/5d096f4e-8dcc-4d24-af9c-e91741498091'
                }
              }
              partHeader: {
                title: 'Environment Overview'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 8
              y: 5
              colSpan: 6
              rowSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'partTitle'
                  value: 'Query 1'
                  isOptional: true
                }
                {
                  name: 'query'
                  value: 'Resources\r\n| where type =~ \'Microsoft.Compute/virtualMachines\'\r\n| extend vmSize = properties.hardwareProfile.vmSize\r\n| summarize count() by tostring(vmSize)\r\n'
                  isOptional: true
                }
                {
                  name: 'chartType'
                  value: 2
                  isOptional: true
                }
                {
                  name: 'isShared'
                  isOptional: true
                }
                {
                  name: 'queryId'
                  value: ''
                  isOptional: true
                }
                {
                  name: 'formatResults'
                  isOptional: true
                }
                {
                  name: 'queryScope'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/ArgQueryChartTile'
              settings: {
              }
              partHeader: {
                title: 'Total Virtual Machines and Sizes'
                subtitle: 'For all customer subscriptions'
              }
            }
          }
          {
            position: {
              x: 14
              y: 5
              colSpan: 10
              rowSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'TimeContext'
                  value: null
                  isOptional: true
                }
                {
                  name: 'ResourceIds'
                  value: [
                    'Azure Monitor'
                  ]
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '${resourcegroupId}/providers/microsoft.insights/workbooks/5d096f4e-8dcc-4d24-af9c-e91741498091'
                  isOptional: true
                }
                {
                  name: 'Type'
                  value: 'workbook'
                  isOptional: true
                }
                {
                  name: 'GalleryResourceType'
                  value: 'Azure Monitor'
                  isOptional: true
                }
                {
                  name: 'PinName'
                  value: 'Support - Environment Overview'
                  isOptional: true
                }
                {
                  name: 'StepSettings'
                  value: '{"version":"KqlItem/1.0","query":"desktopvirtualizationresources\\r\\n| where type == \\"microsoft.desktopvirtualization/hostpools/sessionhosts\\"\\r\\n| where properties[\'sessionHostHealthCheckResults\'][0][\'healthCheckResult\'] == \\"HealthCheckFailed\\" or properties[\'sessionHostHealthCheckResults\'][0][\'healthCheckResult\'] == \\"SessionHostShutdown\\" or properties[\'sessionHostHealthCheckResults\'][0][\'healthCheckResult\'] == \\"Unknown\\" or properties.updateState == \\"Initial\\" or properties.status == \\"Unavailable\\"\\r\\n| summarize count() by id, name, location","size":0,"title":"Unhealthy Session Hosts","noDataMessage":"There Currently NO Unhealthy Session Hosts","noDataMessageStyle":3,"queryType":1,"resourceType":"microsoft.resourcegraph/resources","crossComponentResources":["value::all"],"visualization":"map","mapSettings":{"locInfo":"AzureLoc","locInfoColumn":"location","sizeSettings":"count_","sizeAggregation":"Sum","minSize":10,"maxSize":70,"minData":0,"maxData":50,"defaultSize":0,"labelSettings":"location","legendMetric":"count_","legendAggregation":"Count","itemColorSettings":{"nodeColorField":"count_","colorAggregation":"Sum","type":"thresholds","thresholdsGrid":[{"operator":"Default","thresholdValue":null,"representation":"redBright"}]}}}'
                  isOptional: true
                }
                {
                  name: 'ParameterValues'
                  value: {
                    Subscription: {
                      type: 6
                      value: [
                        'value::all'
                      ]
                      isPending: false
                      isWaiting: false
                      isFailed: false
                      isGlobal: false
                      labelValue: 'All'
                      displayName: 'Subscription'
                      specialValue: [
                        'value::all'
                      ]
                      formattedValue: 'all'
                    }
                    LogAnayltics: {
                      type: 5
                      value: [
                        'value::all'
                      ]
                      isPending: false
                      isWaiting: false
                      isFailed: false
                      isGlobal: false
                      labelValue: 'All'
                      displayName: 'Log Anayltics'
                      specialValue: [
                        'value::all'
                      ]
                      formattedValue: 'all'
                    }
                    TimeRange: {
                      type: 4
                      value: {
                        durationMs: 14400000
                      }
                      isPending: false
                      isWaiting: false
                      isFailed: false
                      isGlobal: false
                      labelValue: 'Last 4 hours'
                      displayName: 'TimeRange'
                      formattedValue: 'Last 4 hours'
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'Location'
                  value: location
                  isOptional: true
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart'
            }
          }
        ]
      }
    ]
    metadata: {
      model: {
      }
    }
  }
}
