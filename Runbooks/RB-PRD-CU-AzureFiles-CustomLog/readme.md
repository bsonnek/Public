 DESCRIPTION
    This script loops through all subscriptions managed by Azure Lighthouse. Powershell Get commands are then used to build a hashtable from the AZ Files storage accounts.
    The hashtable is then written to a centralized custom log table in a log analytics workspace that exists in the managing Lighthouse Tenant