## Azure Virtual Desktop - Workbook

**Warning Most of these workbooks are built to be used in an Azure Lighthouse Environment.**

**Special Thanks to Marcel Meurer and Microsoft AVD Insights Workbooks for a majority of this custom workbook**

**Marcel Meurer  -[LinkedIn](https://www.linkedin.com/in/marcelmeurer/?originalSubdomain=de)**

**https://blog.itprocloud.de/**

### Workbook Overview 
This AVD workbook is a combination of Microsoft, Marcel's , and my own custom workbooks. 

All workbooks and ideas were merged into a single workbook for ease of use by our support team.

## Screenshot of all workbook tabs:
![image](https://user-images.githubusercontent.com/10324197/225495599-298c8a6a-b3ca-4354-935e-44726727a3a7.png)

### Overview Tab:
Original AVD Insights workbook Overview page with a few additions.
1. Search for VM Name. Many times we received a name of a VM but had no idea what host pool it belonged to. This search helped with that.
![image](https://user-images.githubusercontent.com/10324197/225495006-3d7818e2-8ca0-4eee-a975-340209846890.png)

2. Additional Host Health at the bottom of the page to help identify issues with AVD Agents:
![image](https://user-images.githubusercontent.com/10324197/226437589-6f573afa-8d1d-40a6-a8ed-71537988f767.png)

### Connection Diagnostics Tab:
This workgroup is always one of the first places to check when customers are having issues with AVD. Looking over the connection activity for all users or specific users is very helpful for some customers. Some environments have far more issues than others and this is a great place to see those issues right away.
![image](https://user-images.githubusercontent.com/10324197/225499516-0d772fd9-711d-4131-9397-b11f1eadf98d.png)


### Session Bandwidths and Latencies Tab:
**special thanks to Marcel for this query** 

Adding IP to Marcel's query helps troubleshoot users who are not at an office who may exprience unpredicatble latency and bandwidth. Also could indicate users are on Wireless networks. If a user shares the same IP as many others, but has far worse latency it could mean they are on WiFi at the office and should be connected to the network if there is high interference.

![image](https://user-images.githubusercontent.com/10324197/225499947-d59b8c65-1e23-46b7-8195-bc9b017be8ea.png)


### Logon Timing Tab:
**special thanks to Marcel for this query** 

Adding IP to Marcel's query helps track user movement on logons and disconnects. You can see when users could move between offices, locations, hotspots, coffee shops, etc..  you can also determine if they do log out or disconnect when finished working for the day. 

Many times users would have bad policies in place and would not log off for many days causing instability in their enviornments. Having this log data was very helpful.

**Screenshot of a user with a lot of activity and movmenent between offices. Correlating this information to Latency is also helpful to troubleshoot bad latency networks**

![image](https://user-images.githubusercontent.com/10324197/225500856-8f4bb69b-cf37-4d54-90db-74abbb9e4b96.png)



## Host Availability  - This tab requires special custom logs to populate data.




