
<#
.NOTES
  Author: Blair Sonnek
  Creation Date:  10/2022
  Purpose/Change: Monitoring and Alerting of Azure NetApp Files
 
 DESCRIPTION
    Cycle through all Azure NetApp Files and export the storage stats to the Log Analytics workspace custom table
    Alerts will be triggered if the storage usage is above 90% for 30 minutes
    Alerts will be triggered if the Snapshots are older than 2 days
 
 INPUTS
    
 
 OUTPUTS
    Log Analytics Account - LOG-PRD-CU-PlatformLogs-OPS // Custom Log Table "AzureNetAppFilesStats"
 
 LINK
    Useful Link to resources or others.
 
 MODULES
    List Az Modules Required for Script to Run

 RBAC ROLES
  
.CHANGELOG
    2/23/2023 - Sanitized Runbook and Migrated to GitHub - Blair Sonnek
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

## Get Automation Account Variables
$LAWID = Get-AutomationVariable -Name LAW-ANFCustomLogs-ID
$LAWKEY = Get-AutomationVariable -Name LAW-ANFCustomLogs-Key
$LogicAppUri = Get-AutomationVariable -Name LA-ANF-LowStorage
$LogicAppUri2 = Get-AutomationVariable -Name LA-ANF-NoSnapshot


#Variables
$SnapshotThreshold = (Get-Date).AddDays(-2)

#get list of subscriptions
$subscriptionName = Get-AzSubscription
$setcontext = set-AzContext -SubscriptionId $subscriptionName.Id

Write-Output "----STARTING------Subscription Name: $($subscriptionName.Name)"
Write-Output "----WORKING On--Processing subscription $($setcontext.Subscription.Name)-------"
$ANFAccounts = Get-AzResource | Where-Object {$_.ResourceType -eq "Microsoft.NetApp/netAppAccounts/capacityPools/volumes"}
foreach($ANFAccount in $ANFAccounts)
{			
    Write-Output "----WORKING On--Azure NetApp Account-- $($ANFAccount)-------"
    $volumeDetails = Get-AzNetAppFilesVolume -ResourceId $ANFAccount.ResourceId
    foreach($volumeDetail in $volumeDetails)
    {			
        Write-output "----WORKING On--ANF Volume in ANF Account $($ANFAccount.Name)-------"
            $volumeConsumedSizes = @{}
            $endTime = [datetime]::Now.AddDays(-$days)
            $startTime = $endTime.AddMinutes(-30)
            $consumedSize = 0
            $volumeConsumedDataPoints = Get-AzMetric -ResourceId $ANFAccount.ResourceId -MetricName "VolumeLogicalSize" -StartTime $startTime -EndTime $endTime -TimeGrain 00:5:00 -WarningAction:SilentlyContinue -EA SilentlyContinue
            foreach($dataPoint in $volumeConsumedDataPoints.data) {
                if($dataPoint.Average -gt $consumedSize) {
                    $consumedSize = $dataPoint.Average
                }
            }
            $volumeConsumedSizes.add($ANFAccount.ResourceId, $consumedSize)
            $volumePercentConsumed = [Math]::Round(($volumeConsumedSizes[$ANFAccount.ResourceId]/$volumeDetail.UsageThreshold)*100,2)

            Write-output "----WORKING- Find the oldest and most recent snapshots-------"
            $volumeSnaps = @()
            $snapCount = 0
            $volumeSnaps = Get-AzNetAppFilesSnapshot -ResourceGroupName $ANFAccount.ResourceId.split('/')[4] -AccountName $ANFAccount.ResourceId.split('/')[8] -PoolName $ANFAccount.ResourceId.split('/')[10] -VolumeName $ANFAccount.ResourceId.split('/')[12]
            if($volumeSnaps) {
                $mostRecentSnapDate = $volumeSnaps[0].Created
                $oldestSnapDate = $volumeSnaps[0].Created
                foreach($volumeSnap in $volumeSnaps){
                    $snapCount += 1
                    if($volumeSnap.Created -gt $mostRecentSnapDate) {
                        $mostRecentSnapDate = $volumeSnap.Created
                    }
                    if($volumeSnap.Created -lt $oldestSnapDate) {
                        $oldestSnapDate = $volumeSnap.Created
                    }
                }
                Write-output "----WORKING--Oldest-Snapshot-$oldestSnapDate--- Recent-$mostRecentSnapDate-------"
            }
            
        $Body = [PSCustomObject]@{
            Volume = $volumeDetail.name.split('/')[2]
            capacityPool = $volumeDetail.name.split('/')[1]
            netappAccount = $volumeDetail.name.split('/')[0]
            SubscriptionId = $volumeDetail.Id.split('/')[2]
            ResourceGroup = $ANFAccount.ResourceId.split('/')[4]
            Location = $volumeDetail.Location
            Provisioned = $volumeDetail.UsageThreshold/1024/1024/1024
            Consumed = [Math]::Round($volumeConsumedSizes[$ANFAccount.ResourceId]/1024/1024/1024,2)
            Available = [Math]::Round(($volumeDetail.UsageThreshold - $volumeConsumedSizes[$ANFAccount.ResourceId])/1024/1024/1024,2)
            ConsumedPercent = $volumePercentConsumed
            ResourceID = $ANFAccount.ResourceId
            MostRecentSnapshot   = $mostRecentSnapDate.ToString('MM/dd/yyyy hh:mm')
            OldestSnapshot       = $oldestSnapDate.ToString('MM/dd/yyyy hh:mm')
            SnapshotPolicyId = $volumeDetail.DataProtection.Snapshot.SnapshotPolicyId
            BackupPolicyId = $volumeDetail.DataProtection.Backup.BackupPolicyId
            BackupVaultId = $volumeDetail.DataProtection.Backup.VaultId
            BackupEnabled = $volumeDetail.DataProtection.Backup.BackupEnabled
            BackupPolicyEnforced = $volumeDetail.DataProtection.Backup.PolicyEnforced 
            SubnetId = $volumeDetail.SubnetId
        } | ConvertTo-Json

        ### Generate an Alert if Consumed space is over 90
        if($volumePercentConsumed -ge 90)
            {  
                Write-output "----ALERT--Volume Consumed is $volumePercentConsumed - Triggering an Alert for $ANFAccount.Name ------"
                # Logic App - LA-PRD-CU-ANF-LowStorage                      
                $Params = @{
                    Method = "Post"
                    Uri = $LogicAppUri
                    Body = $body
                    ContentType = "application/json"
                }
                Invoke-RestMethod @Params
            }
        
        ### Generate an Alert if Snapshot date is greater than 2 days   
        if($mostRecentSnapDate -lt $SnapshotThreshold)
            {Write-output "----ALERT--Snapshot Date Threshold Exceded $($mostRecentSnapDate) - Triggering an Alert for $ANFAccount.Name ------"                      
            }
            else {Write-Output "----NO ALERT- NOT Over Exipration Date"
            }

        ### Generate an Alert if no Snapshot Policy is detected
        if($volumeDetail.DataProtection.Snapshot.SnapshotPolicyId -eq "" -or $volumeDetail.DataProtection.Snapshot.SnapshotPolicyId -eq $null)
            {  
                Write-output "----ALERT--Snapshot Policy value is Not Found - Triggering an Alert for $($ANFAccount.Name) ------"
                # Logic App - LA-PRD-CU-ANF-NoSnapshot                      
                $Params = @{
                    Method = "Post"
                    Uri = $LogicAppUri2
                    Body = $body
                    ContentType = "application/json"
                }
                Invoke-RestMethod @Params
            }
        
        # Log Analytics Account - LOG-PRD-CU-PlatformLogs-OPS // Custom Log Table "AzureNetAppFilesStats"
        ## Send Output to Log Analytics Workspace Custom Table
        Write-output "----WORKING On--JSON Built-----$Body------"
        $CustomerId = $LAWID
        $SharedKey = $LAWKEY
        $StringToSign = "POST" + "`n" + $Body.Length + "`n" + "application/json" + "`n" + $("x-ms-date:" + [DateTime]::UtcNow.ToString("r")) + "`n" + "/api/logs"
        $BytesToHash = [Text.Encoding]::UTF8.GetBytes($StringToSign)
        $KeyBytes = [Convert]::FromBase64String($SharedKey)
        $HMACSHA256 = New-Object System.Security.Cryptography.HMACSHA256
        $HMACSHA256.Key = $KeyBytes
        $CalculatedHash = $HMACSHA256.ComputeHash($BytesToHash)
        $EncodedHash = [Convert]::ToBase64String($CalculatedHash)
        $Authorization = 'SharedKey {0}:{1}' -f $CustomerId, $EncodedHash
        Write-output "------------Api String Built--------"
        $Uri = "https://" + $CustomerId + ".ods.opinsights.azure.com" + "/api/logs" + "?api-version=2016-04-01"
        $Headers = @{
            "Authorization"        = $Authorization;
            "Log-Type"             = "NetAppFilesStats";
            "x-ms-date"            = [DateTime]::UtcNow.ToString("r");
            "time-generated-field" = $(Get-Date)
        }
    
        $Response = Invoke-WebRequest -Uri $Uri -Method Post -ContentType "application/json" -Headers $Headers -Body $Body -UseBasicParsing
        if ($Response.StatusCode -eq 200) {
            Write-output "------SUCCESS--Stored Event in Log Analytics Workspace-----"
        }
        
    }
}

