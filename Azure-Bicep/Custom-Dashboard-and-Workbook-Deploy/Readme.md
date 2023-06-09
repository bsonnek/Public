## The Conents of this Folder are Deployed using GitHub Actions

**Overview**: This GitHub repo folder is used to manage the Azure Portal Dashboards and Workbooks in Azure Lighthouse Tenants.
This solution will keep the Dashboards and Workbooks in Azure Lighhthouse managing tenants in sync.

### **GitHub Actions**:
  - Dev Branch Push - to '/Monitor/Deploy-DashboardsAndWorkbooks' folder =  Action Will launch Main.bicep on the Lighthouse Tenant


### **Folder Contents**
- 2 x Dashboards
    - Platform Dashboard
    - Support Dashboard
- 8 x Support Workbooks
- 7 x Platform Workbooks


### **Brief: Workbook Update Instructions**
 1. Modify the Azure Monitor Workbook to get the desired results.
 2. Copy the "Gallery Template" JSON from the Workbook Advanced Editor '<>'
 3. In VSCode Create a Dev Branch and Switch to the Dev Branch in VSCode
 4. Find the Workbook .JSON file in the Repo under the Workbooks Folder for the Workbook you are updating.
 5. Delete the existing Contents of the JSON file
 6. Paste the contents into the .JSON workbook file in the GitHub Repo.
