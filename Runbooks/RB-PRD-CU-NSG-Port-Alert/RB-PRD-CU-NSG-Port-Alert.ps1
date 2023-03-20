<#
.NOTES
  Author:         Blair Sonnek
  Creation Date:  1/25/2023
  Purpose/Change: Alerting - Detect if Port 3389 Is open to Any Public IP
 
 SYNOPSIS
    Use Powershell NSG Get Commands to find NSGs with the Platform subnet Name. Then Filter Custom Security Rules that include Port 3389.
 
 DESCRIPTION
    Once a NSG Security rule is found that allows all public IPs to access platform server. A Logic App is sent Rest API details about the resource.
    The Logic App will receive the subscription details, NSG Name, NSG Security rule, and details about what port is allowing traffic from all public ips.
    The Logic App will use this information to create a Zendesk ticket. Support will then investigate the alert and close the port if necessary.
 
 INPUTS
    None
 
 OUTPUTS
    Logic App Triggered by Rest API
 
 LINK
 
 MODULES
    Az.Network
  
.CHANGELOG
    1/25/2023 - Built-Runbook and Started Testing - Blair Sonnek
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
$LogicAppUri = Get-AutomationVariable -Name LA-NSG-PortsOpen

$Names = @()
$subscriptionName = Get-AzSubscription 


foreach($sub in $subscriptionName)
{
	$setcontext = set-AzContext -Subscription $sub.Id
	$subResID = "/subscriptions/" + $setcontext.Subscription.Id
	$allTags = (Get-AzTag -ResourceId $subResID | Select-Object -ExpandProperty Properties | Select-Object -ExpandProperty TagsProperty)
	if($allTags["Monitoring"] -eq "NotRequired")
	{
		Write-Output "---- Processing subscription $($setcontext.subscription.name)-------"	
        
        # Find all NSGs that contain Platform In the name. This Will only focus on Platform subnets with Open Ports to Any Public IP.
		$NSGs=Get-AzResource | Where-Object {$_.ResourceType -eq "Microsoft.Network/networkSecurityGroups"}| Where-Object {$_.Name -like "*Platform*" -or $_.Name -like "*Tenant*"}
        foreach($NSG in $NSGs)
        {
            $NSRulenames = (Get-AzNetworkSecurityGroup -Name $NSG.Name).SecurityRules| Where-Object { $_.DestinationPortRange -contains "3389"}| Select-Object Name
            Write-Output "---- Processing NSG Name $($NSG.Name)-------"	
            # Loop through each Security Rule Name that contains port 3389. Will Trigger a Logic App Alert if Ports are detected to be open.
            foreach($NSRulename in $NSRulenames)
            {
                Write-Output "----Viewing NSG Rule Name: $($NSRulename.Name)"
                $RuleDetails=Get-AzNetworkSecurityGroup -Name $NSG.Name| Get-AzNetworkSecurityRuleConfig -Name $NSRulename.Name
                if($RuleDetails.DestinationPortRange -contains "3389" -and $RuleDetails.SourceAddressPrefix -eq "*" -and $RuleDetails.Direction -eq "Inbound" -and $RuleDetails.Access -eq "Allow"){
                    Write-Warning "Found-!!--3389 Open On RuleName $($NSRulename.Name) in NSG Name $($NSG.Name)"
                    $Names  = @{
                        "NSGName"            = $NSG.Name
                        "SecurityRuleName"   = $NSRulename.Name
                        "SecurityRuleAction" = $RuleDetails.Access
                        "DestinationPort"    = $RuleDetails.DestinationPortRange
                        "TrafficDirection"   = $RuleDetails.Direction
                        "ResourceGroup"      = $NSG.ResourceGroupName
                        "Location"           = $NSG.Location
                        "ResourceType"       = $NSG.ResourceType
                        "ResourceId"         = $NSG.ResourceId 
                        "SubscriptionName"   = $sub.SubscriptionName
                        "SubscriptionId"     = $sub.SubscriptionId
                        "Message"            = "Port 3389 Open to ANY Public IP Address"
                    }
                    $body = ConvertTo-Json -InputObject $Names
                    # Logic App - LA-PRD-CU-NSG-PortsOpen -
                    $Params = @{
                        Method = "Post"
                        Uri = $LogicAppUri
                        Body = $body
                        ContentType = "application/json"
                    }
                    # Sends Details to Logic App
                    Invoke-RestMethod @Params
                }else{
                    Write-Output "--------NOT Found 3389 Open On RuleName $($NSRulename.Name) in NSG Name $($NSG.Name)"
                }
            }
        }
	}
}   
