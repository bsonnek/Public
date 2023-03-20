## Author: Blair Sonnek - 1/10/2023
## Purpose of Runbook##
## Deploy VM Insights Metrics and Session Map features using Azure Monitor DCR Rules. This will only install on Platform VMs with Roles Tags set as "PCManager" and "Business"
## VM extensions required and Deployed by this runbook if not present - AMA (Azure Monitor Agent), MMA (Log Analytics Agent/MicrosoftMonitorAgent), (Dependency Agent)
## When the MMA Agent is present the Dependency Agent will duplicate log data if the enableAMA setting is not set to "False" in the Arm Template.
## One Day when we migrate away from MMA Log Analytics Agent we will need to adjust the enableAMA setting in the arm template to keep Session Map data flowing.

### Custom Settings Specific to this Tenant
### This Runbook points to the Log Analytics Workspace in the VDMS Admin tenant. Custom log tables are used in the Azure Dashboards and Workbooks to for support##



try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

#########################
## Download Templates to C:\Temp
#################################
Write-Output "---Retrieving Template Files from Storage Account)-------"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bsonnek/Public/main/Runbooks/RB-PRD-CU-VMInsights-DCR-Deploy/Deploy-VMInsights-Dcr-Template-SPOTPC.json" -OutFile "C:\temp\Deploy-VMInsights-Dcr-Template-SPOTPC.json"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bsonnek/Public/main/Runbooks/RB-PRD-CU-VMInsights-DCR-Deploy/ExistingVmOnboardingTemplate-enableAMA-False.json" -OutFile "C:\temp\ExistingVmOnboardingTemplate-enableAMA-False.json"

$files = Get-ChildItem -Path 'C:\temp'
Write-Output "---- Listing Files in Local C:\ $files"


#############################
## Process Each Subscription
##############################

$subscriptionName = Get-AzSubscription 


foreach ($sub in $subscriptionName) {
    $setcontext = set-AzContext -Subscription $sub.Id
    $subResID = "/subscriptions/" + $setcontext.Subscription.Id
    Write-Output "-Starting subscription $($setcontext.Subscription.Name)-------"
    $workspaceCheck = Get-AzOperationalInsightsWorkspace
    Write-Output "----Log Analytics Workspace -NAME: $($workspaceCheck.Name)"
    $allTags = (Get-AzTag -ResourceId $subResID | Select-Object -ExpandProperty Properties | Select-Object -ExpandProperty TagsProperty)
    if ($allTags["Monitoring"] -eq "NotRequired") {
        ############  Deploy DCR If Not Exists in Subscription - Using ARM Template Deployments ################
        #################################################
        Write-Output "--Processing subscription $($setcontext.Subscription.Name)-------"
        $DCRGetRule = Get-AzDataCollectionRule | Where-Object {$_.Name -like "VMInsights-DCR"}
        if($DCRGetRule -eq $null){
        Write-Output "----DCR Rule NOT Detected - CREATING-------"
        $workspace = Get-AzOperationalInsightsWorkspace | Where-Object { $_.Name -like "*spotPCLogAnalytics*" }
        Write-Output "----Log Analytics Workspace -NAME: $($workspace.Name)-------"

            $DCRparams = @{
                WorkspaceResourceId = $workspace.ResourceId; 
                WorkspaceLocation   = $workspace.Location
            }

        ## VM Insights DCR Template- PERF and MAP Enabled ARM Template Specific to VM Insights Deployment ###
        New-AzResourceGroupDeployment -ResourceGroupName $workspace.ResourceGroupName -TemplateFile "C:\temp\Deploy-VMInsights-Dcr-Template-SPOTPC.json" -TemplateParameterObject $DCRparams
        Write-Output "----FINISHED CREATING DCR Rule-------"
        }   else {
            Write-Output "----DCR Rule Detected - Skipping Creation-------"
            }   

        ########### Spot PC VM Insights DCR Deployment ##################
        #################################################
        $DCRObject = Get-AzDataCollectionRule | Where-Object { $_.Name -eq "VMInsights-DCR"}
        $workspace = Get-AzOperationalInsightsWorkspace | Where-Object { $_.Name -like "*spotPCLogAnalytics*" }
        #$vms = Get-AzVM -Status | Where-Object { $_.Name -eq "PCManager1" -and $_.PowerState -eq "VM running" }
        $vms = Get-AzVM -Status | Where-Object { $_.Tags.role -eq "PCManager" -and $_.PowerState -eq "VM running" }

        foreach ($vm in $vms) {
            Write-Output "--Checking VM $($vm.name) with Tagged Role:$($vm.Tags.role) -------"
            $allExtensions = (get-azvm -name $vm.name -ResourceGroupName $vm.resourcegroupname | Select-Object -ExpandProperty Extensions | Select-Object VirtualMachineExtensionType).VirtualMachineExtensionType
            $GetRuleAssoc = Get-AzDataCollectionRuleAssociation -TargetResourceId $VM.Id | Where-Object { $_.Name -eq "VMInsights-DCR" }

            
            ## Check to see if VM is Associated to the DCR Rule - If not then Add the VM to the DCR Rule
            if ($GetRuleAssoc -eq $null) {
                Write-Output "----DCR Association NOT Detected VM:$($vm.Name) - Association-------"
                New-AzDataCollectionRuleAssociation -TargetResourceId $vm.Id -AssociationName $DCRObject.Name -RuleId $DCRObject.Id

            }
            else {
                Write-Output "----DCR Association Detected VM:$($vm.Name) - Association------"
            }
            
            ## Checks to see if the AMA Agent or Dependency Agent extensions are configured on the Virtual Machine - If Not then Add them via Arm Template
            if ($allExtensions -notcontains "AzureMonitorWindowsAgent" -or $allExtensions -notcontains "DependencyAgentWindows") {
            Write-Output "----Extension Not Detected on VM:$($vm.Name) - Will now Deploy Extensions and Connect to DCR-------"
            $Deployparams = @{
                VmResourceId        = $VM.Id;
                VmLocation          = $VM.Location;
                osType              = "Windows";
                WorkspaceResourceId = $workspace.ResourceId;
                DcrResourceId       = $DCRObject.Id
            }
    
            ## Depenency Agent to use AMA should be set to False when the MMA Agent is Installed  ###
            New-AzResourceGroupDeployment -ResourceGroupName $workspace.ResourceGroupName -TemplateFile "C:\temp\ExistingVmOnboardingTemplate-enableAMA-False.json" -TemplateParameterObject $Deployparams -AsJob
            }
            else {
                Write-Output "----Extensions Detected on VM:$($vm.Name)-------"
            }

        }
    }
}
