#### Follow these steps to confirm Variables are correct and Security Permissions are correct.

**A runbook was created and needs final configuration to have access to write custom logs and trigger events using logic Apps**

**If you do not follow these instructions to configure the variables in the Automation Account the custom logging will not work**

1. Find Logic App Webhooks - Document both logic app HTTP POST URLs. These URL's will be used as Variables in the Automation Account

![image](https://user-images.githubusercontent.com/10324197/226233850-b513e99c-a40f-4de3-b975-fe871511a6aa.png)


2. Find Log Analytics Workscace ID and Key - These Values will be used to create Variables in the Automation Account
![image](https://user-images.githubusercontent.com/10324197/226233574-b7e1b4cf-e3c2-4b9c-b843-770c00b7b5c8.png)

3. Update Automation Account Variables with Logic App URIs, and LAW ID and Key
![image](https://user-images.githubusercontent.com/10324197/226233219-60ac3303-a223-49ac-a22d-8042006fd646.png)

![image](https://user-images.githubusercontent.com/10324197/226232335-20619f5e-7c31-4018-a531-3472c9ef2710.png)


4. Create a Schedule for the Runbook - Find the Runbook in the Autotomation Account. Then Link it to a new schedule:

![image](https://user-images.githubusercontent.com/10324197/226234709-d3835b14-3b31-4b49-85ec-9fac89ac8f4d.png)

5. Allow the Automation Account Managed Identity permission - For now allow Reader permissions to the Subscription.
    - Search Azure for Subscriptions - Select the subscription with your ANF Volumes
![image](https://user-images.githubusercontent.com/10324197/226240725-b303c348-cb47-4aec-9e2a-9ed121c79596.png)
![image](https://user-images.githubusercontent.com/10324197/226240433-72316f4e-0950-442e-b430-ee03c4c7386b.png)
![image](https://user-images.githubusercontent.com/10324197/226240980-3cc5a29c-23d0-4067-bb1c-7b50aaa3c4a1.png)
![image](https://user-images.githubusercontent.com/10324197/226241231-8f472c51-660f-4513-a070-1f63dfaabbbe.png)
    - Click Review and Assign




