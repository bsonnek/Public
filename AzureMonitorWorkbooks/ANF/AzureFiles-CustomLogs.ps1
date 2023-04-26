## Author - Blair Sonnek
## Purpose of Runbook##
## Cycle through all Azure File shares and export the storage stats to the Log Analytics workspace custom table

### Custom Settings Specific to this Tenant
### This Runbook points to the Log Analytics Workspace in the Admin tenant. Custom log tables are used in the Azure Dashboards and Workbooks to for support##
try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

#Variables

#get list of subscriptions
$subscriptionName = Get-AzSubscription 


Write-Output "----First part started-------"
#search in each subscription
foreach($sub in $subscriptionName)
{
    #select the subscription
    $setcontext = set-AzContext -Subscription $sub.Id

	$subResID = "/subscriptions/" + $setcontext.Subscription.Id
	$allTags = (Get-AzTag -ResourceId $subResID | Select-Object -ExpandProperty Properties | Select-Object -ExpandProperty TagsProperty)
	if($allTags["Monitoring"] -eq "Required")
	{
		Write-Output "----Processing subscription $($setcontext.Subscription.Name)-------"
		$sas=Get-AzStorageAccount
		foreach($sa in $sas)
		{
			Write-output "----Working on storage account $($sa.StorageAccountName)-------"
			$fileShares = Get-AzRmStorageShare -ResourceGroupName $sa.ResourceGroupName -StorageAccountName $sa.StorageAccountName
            foreach($fileShare in $fileShares)
		    {
				
				Write-output "----Working on file share $($fileShare.Name) for storage account $($sa.StorageAccountName)-------"
				$shareUsage = Get-AzRmStorageShare -ResourceGroupName $sa.ResourceGroupName -StorageAccountName $sa.StorageAccountName -Name $fileShare.Name -GetShareUsage
				
				$usageBytes = $shareUsage.shareUsageBytes
				$usageBytesInMB = [Math]::Round($usageBytes/1024/1024,2)
                $usageBytesInGB = [Math]::Round($usageBytesInMB/1024,2)
			    $quota = $shareUsage.QuotaGiB
				$percentageUtilization = [Math]::Round(($usageBytesInGB/$quota)*100,2)
				$accesstier = $shareUsage.AccessTier
					
				$Body = [PSCustomobject]@{
					StorageName              =$sa.StorageAccountName
					StorageRG                =$sa.ResourceGroupName
					FileShareName            =$fileShare.Name
					FileShareQuota           =$quota
					PercentUtilization       =$percentageUtilization
					UsageInGB                =$usageBytesInGB
					UsageInMB                =$usageBytesInMB
					StorageKind              =$sa.Kind
					AccessTier               =$accesstier
					SubscriptionId           =$setcontext.Subscription.id
					SubscriptionName         =$setcontext.Subscription.Name
				} | ConvertTo-Json

				## Send Output to Log Analytics Workspace Custom Table
				Write-output "------JSON Built-----$Body------"
                $CustomerId = ""
                $SharedKey = ""
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
                    "Log-Type"             = "AzureFileStats";
                    "x-ms-date"            = [DateTime]::UtcNow.ToString("r");
                    "time-generated-field" = $(Get-Date)
                }

				$Response = Invoke-WebRequest -Uri $Uri -Method Post -ContentType "application/json" -Headers $Headers -Body $Body -UseBasicParsing
				if ($Response.StatusCode -eq 200) {
					Write-output "------Logs are Successfully Stored in Log Analytics Workspace-----"
				}
									
			}
		}
	}
}
