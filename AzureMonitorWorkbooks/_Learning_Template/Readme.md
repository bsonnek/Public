### The goal of this guide is to assist you in creating your initial workbook in Azure Monitor. By utilizing the json code provided in this folder, the workbook you create will give you a template for your training environment, complete with pre-built queries. These examples serve as a point of reference during your learning process, showcasing how to query various types of data sources with basic examples. **

### This workbook is also a great starter template that will include core concepts like parameters, groups, and tabs to start out any workbook.

#### Once you create a workbook you can then learn basic KQL queries and the components of a workbook. Use the additional links at the bottom for more video training on Workbooks and KQL training.**

1.  **First Start out by creating your own workbook from a template that will show examples of different workbook features.**
    1.  Login to the Azure Portal --> Go to Azure Monitor - Workbooks
        1.  Create a "New" Workbook using the screenshot below
            1.  ![image](https://user-images.githubusercontent.com/10324197/222852231-eab3c662-ffd5-4a95-b026-a0a3d8692c3f.png)
        2.  Select the </> Option in the new workbook and paste in the Code **from the JSON in this Folder**
             [JSON LInk](https://github.com/bsonnek/Public/blob/main/AzureWorkbooks/_Learning_Template/Workbook_Template.json)
            1.  ![image](https://user-images.githubusercontent.com/10324197/222852295-7cfef0df-5727-4132-b6e4-0d6591bf5427.png)

            2.  ![image](https://user-images.githubusercontent.com/10324197/222852360-7f92c654-36ba-45fc-83c4-3cc086e69aca.png)
            3.  Save As and Name your new workbook - 
                1.  ![image](https://user-images.githubusercontent.com/10324197/222852408-73e6d390-8e6f-4eb2-9aae-83a493ce5dfb.png)
    2.  Once you have your new workbooks saved you can now Edit the workbook and see the components of a workbook.
        1.  Research the Workbook Items Topics - <https://github.com/microsoft/Application-Insights-Workbooks/tree/master/Documentation>
            1.  Parameters
                1.  Typically kept at the top of a workbook to populate what queries have access to. 
                    1.  We mainly use parameters to query the Azure Resource Graph to select subscriptions, Log Analytics Workspace, and other Azure Resources. 
            2.  Data Sources (3 primary locations where data can be queried from)
                1.  Log Analytics Workspace Logs (KQL)

                    1.  Typically data from Azure Platform Services are written to LAW logs in each customer subscription
                2.  Resource Graph Explorer (ARG)
                    1.  Azure Resources can typically be queried by ARG queries. ARG is a temporary database in Azure to query resources in the Azure Environment. Data is gathered from the Azure Resource Manager and written to the ARG for 14 days.
                3.  Azure Resource Manager (REST API)
                    1.  This is only used in a workbook when the information can't be found in the ARG.  
            3.  Groups
                1.  Great for grouping queries on topic. Also Groups will prevent all the queries from running at once and slowing down your workbook
            4.  Links and Tabs
                1.  Great for allowing groups to become visible when a tab is selected
    3.  Different locations in the Azure Portal to gain more knowledge on what to query and to gather ideas
        1.  Log Analytics Workspace Logs -
            1.  Run Queries directly from a specific Log Analytics Workspace Table - This will help you find different Tables and prebuilt queries in Azure
        2.  Resource Graph Explorer (ARG)
            1.  Run Queries directly from the "Azure Resource Graph" - This will help you find different Tables and prebuilt queries on ARG Topics
        3.  Resource Explorer
            1.  This will help understand Azure Resource Provider types and how Resource IDs are linked to different Azure resources. You can also use this find resources in subscriptions that you can query from the ARG.

### Example of the template workbook
![image](https://user-images.githubusercontent.com/10324197/222858400-df615032-149f-44da-ab4f-148b8897acd0.png)


-   Learning Resources 
    -   Best place to start- Rod Trent - Must Learn KQL - <https://github.com/rod-trent/MustLearnKQL>
    -   TeachJing - YouTube Series on Learning KQL - [KQL Tutorial Series | Straight Basics | EP1](https://www.youtube.com/watch?v=UwcBvVkTCpc&t=15s)
    -   Microsoft Getting Started with Workbooks - [How to get started with Azure Monitor Workbooks](https://www.youtube.com/watch?v=KO3XppZSOeE)
    -   Microsoft How to Build Workbooks - [How to build Azure Workbooks using logs and parameters | Azure Portal Series](https://www.youtube.com/watch?v=EC7n1Oo6D-o&t=357s)
-   Website Links for information gathering
    -   Text Editor Help - [Markdown Cheat Sheet | Markdown Guide](https://www.markdownguide.org/cheat-sheet/)
