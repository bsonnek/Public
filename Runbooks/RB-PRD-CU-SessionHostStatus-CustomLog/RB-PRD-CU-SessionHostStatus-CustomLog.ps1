
<#
.NOTES
  Author: Blair Sonnek
  Creation Date:  10/2022
  Purpose/Change: Alerting and Monitoring
 
 DESCRIPTION
    Purpose of runbook is to gather all session host details in all subscriptions and log status to a custom log analytics table
 
 INPUTS
    Inputs if any, otherwise state None
 
 OUTPUTS
    Log Analytics Workspace - LOG-PRD-CU-PlatformLogs-OPS // Custom Log Table "AzureWVDSessionHosts"
 
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

$LAWID = Get-AutomationVariable -Name LOG-PlatformLogs-ID
$LAWKEY = Get-AutomationVariable -Name LOG-PlatformLogs-Key

$now=(Get-Date).ToString("o")
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
		Write-Output "-----Processing subscription $($setcontext.Subscription.Name)-------"
		$avdPools=Get-AzResource | Where-Object {$_.ResourceType -eq "Microsoft.DesktopVirtualization/hostpools"}
        
		foreach($avdPool in $avdPools)
		{			
            Write-Output "--AVD Pool Name-- $($avdPool.Name)-------"
            $pools=Get-AzWvdHostPool -Name $avdPool.Name -ResourceGroupName $avdPool.ResourceGroupName
            foreach($pool in $pools)
            {			
                Write-output "----Working Pool $($pool.Name)-------"
                $sessionHosts=Get-AzWvdSessionHost -HostPoolName $pool.Name -ResourceGroupName $avdPool.ResourceGroupName
                Write-output "Number of session hosts: $($sessionHosts.Count)"
                foreach($sessionHost in $sessionHosts)
                {	
                    $sessionHost | Add-Member -MemberType NoteProperty -Name "TimeStamp" -Value $now
					$VMNameSplit=$sessionHost.Name.split('/')[1]
                    $VMName=$VMNameSplit.split('.')[0]
                    $VMNameStatus=Get-AzVM -VMName $VMName -Status
                    Write-output "------Session Host Name $($sessionHost.Name)--And Status $($sessionHost.Status)-------"
                    
                    $Body = [PSCustomObject]@{
                        TimeGenerated      = $sessionHost.TimeStamp
                        SubscriptionId     = $setcontext.Subscription.Id
                        AgentVersion       = $sessionHost.AgentVersion 
                        AllowNewSession    = $sessionHost.AllowNewSession
                        AssignedUser       = $sessionHost.AssignedUser
						HealthCheckResult  = $sessionHost.HealthCheckResult 
                        HostPoolId         = $sessionHost.HostPoolId
                        HostName           = $sessionHost.Name.split('/')[1]
                        PoolName           = $sessionHost.Name.split('/')[0]
                        OSVersion          = $sessionHost.OSVersion
                        CurrentSessions    = $sessionHost.Session
                        HostAvailable      = $sessionHost.Status.ToString()
                        StatusTimestamp    = $sessionHost.StatusTimestamp
                        SxSStackVersion    = $sessionHost.SxSStackVersion 
                        UpdateState        = $sessionHost.UpdateState.ToString()
                        UpdateErrorMessage = $sessionHost.UpdateErrorMessage
                        VirtualMachineId   = $sessionHost.VirtualMachineId
						VMPowerState       = $VMNameStatus.PowerState.ToString()
                    } | ConvertTo-Json

                    ## Send Output to Log Analytics Workspace Custom Table -- LOG-PRD-CU-PlatformLogs-OPS
                    Write-output "------JSON Built-----$Body------"
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
                        "Log-Type"             = "SessionHostStatus";
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
}
