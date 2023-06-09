###################################
### Commands to create Identity ###
###################################

## PROD - Run this from Azure CLI Cloud shell in your subscription
az ad sp create-for-rbac --name "GitHub-PROD-Monitoring" --role contributor --scopes /subscriptions/##########################/resourceGroups/RG-PRD-EU-Support-Dashboards --sdk-auth


# Save the output to a clipboard and use to create the secrets in Github Actions for the repo
# Go to Github and create a Secret for Actions:
Names: 
CLIENT_ID
CLIENT_SECRET
SUBSCRIPTION_ID
TENANT_ID
