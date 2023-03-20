<#
.NOTES
  Author:         Blair Sonnek
  Creation Date:  2/6/2023
  Purpose/Change: Monitor Azure VMs for missing Managed Identities used for SpotPC Automation
 
 SYNOPSIS
    Using Azure Resource Graph Query in a Powershell runbook, query all  VMs and determine if the VM has the correct System and User Assigned identities.
    If the Identities are missing a Logic App is triggered and a Zendesk ticket will be created for investigation.
 
 DESCRIPTION
    An Azure Resource Graph Query looks only at  VMs in all subscriptions. The query then counts if either User Identities exist. 
    Powershell is then used to determine if the count value is 0(notfound) or 1(found) and will alert if 0. A Logic App is then triggered via rest API webhook and passed paramaters.
    The Logic app will then generate a Zendesk ticket with the passed parameters.
 
 INPUTS
    Azure Resource Graph Query
 
 OUTPUTS
    Logic App web hook triggered with the following parameters. - subscriptionId, id, IdentityTypes, name
 
 LINK

 
 MODULES
    Az.ResourceGraph
  
.CHANGELOG
    2/6/2023 - Create Runbook
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
$LogicAppUri = Get-AutomationVariable -Name LA-VM-ManagedIdentity

## Azure Resource Graph Query to find VM Identities
$GraphSearchQuery = "Resources
    | where type =~ 'Microsoft.Compute/virtualMachines'
    | where name == 'YourVMHere'
    | extend IdentityTypes=tostring(identity.type)
    | extend UserAssignedIdentities=identity.userAssignedIdentities
    | summarize UserYourVMHere = countif(identity contains 'YourVMHere'), UserTenantVMs = countif(identity contains 'TenantVMs') by subscriptionId, id, IdentityTypes, name"

try {
    $spotmgrvms = Search-AzGraph -Query $GraphSearchQuery
}
catch {
    Write-Error "Failure running Search-AzGraph, $_"
}


## For Each Query Result we will determine if the count value Equals 0(notfound) or 1(found). 
foreach($spotmgrvm in $spotmgrvms)
{
    $GraphSearchQuery2 = "resourcecontainers
    | where subscriptionId == '$($spotmgrvm.subscriptionId)'
    | where type == 'microsoft.resources/subscriptions'
    | extend subscriptionName = name
    | extend Monitoring = tags.Monitoring
    | project subscriptionName, Monitoring"
	try {
		$subname = Search-AzGraph -Query $GraphSearchQuery2
	}
	catch {
		Write-Error "Failure running Search-AzGraph, $_"
	}
    
    
    ## Query to find the Subscription Name for Output messages

    Write-Output "PROCESSING--- VM $($spotmgrvm.Name) in Subscription Name: $($subname.subscriptionName)"
    Write-Output "---Monitoring Value: $($subname.Monitoring)"
	
    if ($subname.Monitoring -cne "NotRequired") {
        Write-Output "---Monitoring Is Required"
        ## Checks for User YourVMHere eq 0 then a logic app is triggered to create a Zendesk ticket
        if ($spotmgrvm.UserYourVMHere -eq 0) {
            Write-Warning "---Missing User YourVMHere User Identity in Subscription Name: $($subname.subscriptionName)"
            Write-Output "!!--Missing User YourVMHere User Identity in Subscription Name: $($subname.subscriptionName)"
            $Names = @()
            $Names  = @{
                "VMName"             = $spotmgrvm.name
                "IdentityType"		 = "YourVMHere User Identity"
                "ResourceId"         = $spotmgrvm.id
                "SubscriptionId"     = $spotmgrvm.subscriptionId
                "SubscriptionName"   = $subname.subscriptionName
            }
            $body = ConvertTo-Json -InputObject $Names

            $Params = @{
                Method = "Post"
                Uri = $LogicAppUri
                Body = $body
                ContentType = "application/json"
            }
            # Sends Details to Logic App
            Invoke-RestMethod @Params
        }	else{
                Write-Output "---Found SpotPCManger1 User Identity"
            }

        ## Checks for Any User Idenity with the name TenantVMs- eq 0 then a logic app is triggered to create a Zendesk ticket
        if ($spotmgrvm.UserTenantVMs -eq 0) {
            Write-Warning "---Missing User TenantVMs Managed Identity in Subscription Name: $($subname.subscriptionName)"
            Write-Output "!!--Missing User TenantVMs Managed Identity in Subscription Name: $($subname.subscriptionName)"
            $Names = @()
            $Names  = @{
                "VMName"             = $spotmgrvm.name
                "IdentityType"		 = "TenantVM User Identity"
                "ResourceId"         = $spotmgrvm.id
                "SubscriptionId"     = $spotmgrvm.subscriptionId
                "SubscriptionName"   = $subname.subscriptionName
            }
            $body = ConvertTo-Json -InputObject $Names
            
            $Params = @{
                Method = "Post"
                Uri = $LogicAppUri
                Body = $body
                ContentType = "application/json"
            }
            # Sends Details to Logic App
            Invoke-RestMethod @Params	
        }	else{
                Write-Output "---Found User TenantVMs Identity"
            }
    }
}