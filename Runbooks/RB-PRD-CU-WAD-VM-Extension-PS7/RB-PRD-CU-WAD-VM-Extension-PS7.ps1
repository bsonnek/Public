<#
.NOTES
  Author: Blair Sonnek
  Creation Date:  01/05/2023
  Purpose/Change: Reduce log ingestion cost by shipping security events directly to Event Hub and not to Log Analytics Workspace
 
 DESCRIPTION
    Loop through all VMs in each subscription - Determine if the WAD Extension is detected on a Virtual Machine and Install if missing
    The WAD Extensions requires a special JSON diagnostic config file with Location Specific Event Hubs.
 
 INPUTS
    Inputs if any, otherwise state None
 
 OUTPUTS
    Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log
 
 LINK
    Useful Link to resources or others.
 
 MODULES
    Powershell 7 required for JSON Depth

 RBAC ROLES
  
.CHANGELOG
    2/27/2023 - Sanitized Runbook and Migrated to GitHub - Blair Sonnek
#>

try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

### Create Variable for subscription context where the Event Hubs are located
$EventHubSubscription = "xxxxx-xxxxxxx-xxxxxxx-xxxxxxx-xxxxxxx"


## Set Context to VDMS Admin Subscription to build Event Hub Table
Set-AzContext -SubscriptionId $EventHubSubscription
### Create Event Hub Table to be used later to determine the location of the Event Hub and match it to the VM Location.
$EventHubtable = @()

Write-Output "----Building Event Hub Table ----"
$EventHubNamespaces = get-azresource  -ResourceType "Microsoft.EventHub/namespaces" | Where-Object {$_.Name -like '*eventhub-spot'}
foreach($EventHubNamespace in $EventHubNamespaces)
{
    $EventHubNamespace | Select-Object -Property *
    $EventHubs = Get-AzEventHub -NamespaceName $EventHubNamespace.Name -ResourceGroupName $EventHubNamespace.ResourceGroupName
    $EventHubKey = Get-AzEventHubKey -ResourceGroupName $EventHubNamespace.ResourceGroupName -NamespaceName $EventHubNamespace.Name -EventHubName "qradar" -Name "qradarpolicy"

    $EventHubObject = [PSCustomobject]@{
        Location         =$EventHubNamespace.Location
        NameSpaceName    =$EventHubNamespace.Name
        HubName          =$EventHubs.Name
        HubKeyName       =$EventHubKey.KeyName
        HubKey           =$EventHubKey.PrimaryKey
    }
    $EventHubtable += $EventHubObject
}
Write-Output "----Event Hub Table Created-------"

#get list of subscriptions
$subscriptionName = Get-AzSubscription


Write-Output "----START -- Processing Subscriptions Now-------"
#search in each subscription
foreach($sub in $subscriptionName){
    
    #select the subscription
    $setcontext = set-AzContext -Subscription $sub.Id
    Write-Output "----Starting - Subscription Name - $($sub.Name) -------"
    $subResID = "/subscriptions/" + $setcontext.Subscription.Id
    $allTags = (Get-AzTag -ResourceId $subResID | Select-Object -ExpandProperty Properties | Select-Object -ExpandProperty TagsProperty)
    if($allTags.keys -notcontains "Monitoring" -or $allTags["Monitoring"] -ne "NotRequired"){
        
        ##### Check and Create Storage Account IF it doesn't exist REQUIRED in Subscription ####### 
        $GetRG = Get-AzVM  | Where-Object {$_.Name -eq 'cwmgr1'}
        $ResourceGroupName = $GetRG.ResourceGroupName
        $Location = $GetRG.Location
        $randomnumber = Get-Random -Minimum 1000 -Maximum 9999
        $StorageAccountCreate = "waddiaglogs" + $randomnumber
        $CheckStorageAcct=Get-AzResource | Where-Object {$_.ResourceType -eq "Microsoft.Storage/storageAccounts"}
        Write-Output "----Location of Resource Group - $($Location) -------"

        if ($CheckStorageAcct.name -like "waddiaglogs*"){
            $StorageAccount = $CheckStorageAcct | Where-Object {$_.Name -like "waddiaglogs*"}
            Write-Output "--- Found Storage Account -$($StorageAccount.Name) - Skipping Creation of New Storage Account"
        }
            else{
                $null = New-AZStorageAccount -ResourceGroupName $ResourceGroupName `
                    -Name $StorageAccountCreate `
                    -Location $Location `
                    -SkuName Standard_LRS `
                    -Kind StorageV2  
                Write-Output  "--- Didn't Find Storage Account - Creating New Storage Account Name--$StorageAccountCreate"
                Start-Sleep -Seconds 60
                $CheckStorageAcct2=Get-AzResource | Where-Object {$_.ResourceType -eq "Microsoft.Storage/storageAccounts"}
                $StorageAccount = $CheckStorageAcct2 | Where-Object {$_.Name -like "waddiaglogs*"}
                Write-Output  "----New Storage Account Created - $($StorageAccount.Name)"          
            }
        
        ## Start Processing VMs Now that all Prereqs are in place
        Write-Output "----Find Running VMs and Install WAD Extension If Not Currently Installed"    
        $VMs = Get-AzVM -status | Where-Object {$_.Powerstate -eq 'VM running'}
        foreach ($VM in $VMs){
            
            Write-Output "----Processing VM Name --- $($VM.Name)"
            $allExtensions = (get-azvm -name $VM.name -ResourceGroupName $VM.resourcegroupname | Select-Object -ExpandProperty Extensions | Select-Object VirtualMachineExtensionType).VirtualMachineExtensionType
            if($allExtensions -notcontains "IaaSDiagnostics") {
                Write-Output "-------VM $($VM.Name) Does Not Have Extension"
                foreach ($EventHub in $EventHubtable){
                    if($EventHub.Location -eq $VM.Location) {
                    ### Build Resource Template JSON ### 
                    $URL = "https://" + $EventHub.NameSpaceName + ".servicebus.windows.net/qradar"
                    #Antimalware extension settings, exclusions and schedule
                    $WADDiagsettings = @'
                        {
                            "WadCfg": {
                                "DiagnosticMonitorConfiguration": {
                                    "overallQuotaInMB": 1024,
                                    "WindowsEventLog": {
                                        "scheduledTransferPeriod": "PT1M",
                                        "sinks": "myEventHub",
                                            "DataSource": [
                                            {
                                            "name": "Security!*[System[(EventID &gt;=4727 and EventID &lt;=4735) or (EventID &gt;=4754 and EventID &lt;=4758) or (EventID &gt;=4722 and EventID &lt;=4726) or (EventID &gt;=4765 and EventID &lt;=4767) or (EventID &gt;=4904 and EventID &lt;=4908) or (EventID &gt;=4716 and EventID &lt;=4718) or (EventID &gt;=4864 and EventID &lt;=4867)]]"
                                            },
                                            {
                                            "name": "Security!*[System[(EventID=1102 or EventID=4776 or EventID=4777 or EventID=4768 or EventID=4771 or EventID=4772 or EventID=4782 or EventID=4737 or EventID=4764 or EventID=4720 or EventID=4738 or EventID=4740 or EventID=4780 or EventID=4781 or EventID=4794 or EventID=5376 or EventID=5377 or EventID=4688 or EventID=4634 or EventID=4624)]]"
                                            },
                                            {
                                            "name": "Security!*[System[(EventID=4625 or EventID=4648 or EventID=4675 or EventID=4964 or EventID=4625 or EventID=5140 or EventID=4657 or EventID=4698 or EventID=4715 or EventID=4719 or EventID=4817 or EventID=4902 or EventID=4912 or EventID=4713 or EventID=4739 or EventID=4697)]]"
                                            }
                                        ]
                                    }
                                },
                                "SinksConfig": {
                                    "Sink": [
                                        {
                                            "name": "myEventHub",
                                            "EventHub": {
                                                "Url": "",
                                                "SharedAccessKeyName": ""
                                            }
                                        }
                                    ]
                                }
                            },
                            "PrivateConfig": {
                                "EventHub": {
                                    "Url": "" ,
                                    "SharedAccessKeyName": "",
                                    "SharedAccessKey": ""
                                }
                            },
                            "IsEnabled": "true"
                        }
'@ | ConvertFrom-Json -depth 10
                    ### Adding Custom Values to JSON Diagnostics Configuration File ## 
                    $WADDiagsettings.WadCfg.SinksConfig.Sink[0].EventHub.Url = $URL
                    $WADDiagsettings.WadCfg.SinksConfig.Sink[0].EventHub.SharedAccessKeyName = $EventHub.HubKeyName
                    $WADDiagsettings.PrivateConfig.EventHub.Url = $URL
                    $WADDiagsettings.PrivateConfig.EventHub.SharedAccessKeyName = $EventHub.HubKeyName
                    $WADDiagsettings.PrivateConfig.EventHub.SharedAccessKey = $EventHub.HubKey
                    ## Convert JSON to File location
                    $jsonfile = $env:TEMP + "\wad-private-configuration.json"
                    $WADDiagsettings | ConvertTo-Json -depth 10 | Set-Content $jsonfile
                    Write-Output "----File Config path location $jsonfile"
                    Write-Output "----VM Name $($VM.Name)"
                    Write-Output "--STARTING Deployment to Storage Account Name $($StorageAccount.Name)"
                    Write-Output "----EventHub Location -$($EventHub.Location)- and Name -$($EventHub.NameSpaceName)- and KeyName -$($EventHub.HubKeyName)"
            
                    ### Deploy Resource Template for WAD Diag Extension ### 
                    Set-AzVMDiagnosticsExtension -ResourceGroupName $VM.ResourceGroupName -VMName $VM.Name -DiagnosticsConfigurationPath $jsonfile -StorageAccountName $StorageAccount.Name
                    Write-Output "--COMPLETE Deploy On VM Name - $($VM.Name)"
                    }
                }
            }
                else{

                    Write-Output  "--VM Name $($VM.Name) - Has Extension Already"          
                }
        }
    }
}