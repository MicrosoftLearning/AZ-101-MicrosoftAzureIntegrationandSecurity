# AZ 101 Module 4 - Secure Identities
# Lab 2: Implement and validate Azure AD Identity Protection

Estimated Time: 90 minutes

All tasks in this lab are performed from the Azure portal, except for steps in Exercise 2 performed within a Remote Desktop session to an Azure VM.

Lab files: none

### Scenario
  
Adatum Corporation wants to take advantage of Azure AD Premium features for Identity Protection


### Objectives
  
After completing this lab, you will be able to:

-  Deploy an Azure VM by using an Azure Resource Manager template

-  Implement Azure MFA

-  Implement Azure AD Identity Protection


### Exercise 0: Prepare the lab environment
  
Estimated Time: 15 minutes

The main tasks for this exercise are as follows:

1. Deploy an Azure VM by using an Azure Resource Manager template


#### Task 1: Deploy an Azure VM by using an Azure Resource Manager template

1. From the lab virtual machine, start Microsoft Edge, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using a Microsoft account that has the Owner role in the Azure subscription you intend to use in this lab.

1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Template deployment**.

1. Use the list of search results to navigate to the **Custom deployment** blade.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, load the template file **az-101-04b_azuredeploy.json**. 

   > **Note**: Review the content of the template and note that it defines deployment of an Azure VM hosting Windows Server 2016 Datacenter.

1. Save the template and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, navigate to the **Edit parameters** blade.

1. From the **Edit parameters** blade, load the parameters file **az-101-04b_azuredeploy.parameters.json**. 

1. Save the parameters and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, initiate a template deployment with the following settings:

    - Subscription: the name of the subscription you are using in this lab

    - Resource group: the name of a new resource group **az1010401b-RG**

    - Location: the name of the Azure region which is closest to the lab location and where you can provision Azure VMs

    - Vm Size: **Standard_DS1_v2**

    - Vm Name: **az1010401b-vm1**

    - Admin Username: **Student**

    - Admin Password: **Pa55w.rd1234**

    - Virtual Network Name: **az1010401b-vnet1**

   > **Note**: To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

   > **Note**: Do not wait for the deployment to complete but proceed to the next exercise. You will use the virtual machine included in this deployment in the last exercise of this lab.

> **Result**: After you completed this exercise, you have initiated a template deployment of an Azure VM **az1010401b-vm1** that you will use in the next exercise of this lab.


## Exercise 1: Implement Azure MFA

Estimated Time: 45 minutes

The main tasks for this exercise are as follows:

1. Create a new Azure AD tenant

1. Activate Azure AD Premium v2 trial

1. Create Azure AD users and groups

1. Assign Azure AD Premium v2 licenses to Azure AD users

1. Configure Azure MFA settings, including fraud alert, trusted IPs, and app passwords

1. Validate MFA configuration


#### Task 1: Create a new Azure AD tenant

1. In the Azure portal, navigate to the **New** blade. 

1. From the **New** blade, search Azure Marketplace for **Azure Active Directory**.

1. Use the list of search results to navigate to the **Create directory** blade.

1. From the **Create directory** blade, create a new Azure AD tenant with the following settings: 

  - Organization name: **AdatumLab101-4b**

  - Initial domain name: a unique name consisting of a combination of letters and digits. 

  - Country or region: **United States**

   > **Note**: Take a note of the initial domain name. You will need it later in this lab. 


#### Task 2: Activate Azure AD Premium v2 trial

1. In the Azure portal, set the **Directory + subscription** filter to the newly created Azure AD tenant.

   > **Note**: The **Directory + subscription** filter appears to the right of the Cloud Shell icon in the toolbar of the Azure portal 

   > **Note**: You might need to refresh the browser window if the **AdatumLab101-4b** entry does not appear in the **Directory + subscription** filter list.

1. In the Azure portal, navigate to the **AdatumLab101-4b - Overview** blade.

1. From the **AdatumLab101-4b - Overview** blade, navigate to the **Licenses - Overview** blade.

1. From the **Licenses - Overview** blade, navigate to the **Products** blade. 

1. From the **Products** blade, navigate to the **Activate** blade and activate **Azure AD Premium P2** free trial.


#### Task 3: Create Azure AD users and groups.

1. In the Azure portal, navigate to the **Users - All users** blade of the AdatumLab101-4b Azure AD tenant.

1. From the **Users - All users** blade, create a new user with the following settings:

    - Name: **aaduser1**

    - User name: **aaduser1@***<DNS-domain-name>***.onmicrosoft.com** where *<DNS-domain-name>* represents the initial domain name you specified in the first task of this exercise. 

   > **Note**: Take a note of this user name. You will need it later in this lab.

    - Profile: **Default**

    - Properties: **Default**

    - Groups: **0 groups selected**

    - Directory role: **User**

    - Password: select the checkbox **Show Password** and note the string appearing in the **Password** text box. You will need it later in this lab.

1. From the **Users - All users** blade, create a new user with the following settings:

    - Name: **aaduser2**

    - User name: **aaduser2@***<DNS-domain-name>***.onmicrosoft.com** where *<DNS-domain-name>* represents the initial domain name you specified in the first task of this exercise. 

   > **Note**: Take a note of this user name. You will need it later in this lab.

    - Profile: **Default**

    - Properties: **Default**

    - Groups: **0 groups selected**

    - Directory role: **User**

    - Password: select the checkbox **Show Password** and note the string appearing in the **Password** text box. You will need it later in this lab.


#### Task 4: Assign Azure AD Premium v2 licenses to Azure AD users

   > **Note**: In order to assign Azure AD Premium v2 licenses to Azure AD users, you first have to set their location attribute.

1. From the **Users - All users** blade, navigate to the **aaduser1 - Profile** blade and set the **Usage location** to **United States**.

1. From the **aaduser1 - Profile** blade, navigate to the **aaduser1 - Licenses** blade and assign to the user an Azure Active Directory Premium P2 license with all licensing options enabled.

1. Return to the **Users - All users** blade, navigate to the **aaduser2 - Profile** blade, and set the **Usage location** to **United States**.

1. From the **aaduser2 - Profile** blade, navigate to the **aaduser2 - Licenses** blade and assign to the user an Azure Active Directory Premium P2 license with all licensing options enabled.

1. Return to the **Users - All users** blade, navigate to the Profile entry of your user account and set the **Usage location** to **United States**.

1. Navigate to **Licenses** blade of your user account and assign to it an Azure Active Directory Premium P2 license with all licensing options enabled.

1. Sign out from the portal and sign back in using the same account you are using for this lab. 

   > **Note**: This step is necessary in order for the license assignment to take effect. 


#### Task 5: Configure Azure MFA settings.

1. In the Azure portal, navigate to the **Users - All users** blade of the AdatumLab101-4b Azure AD tenant.

1. From the **Users - All users** blade of the AdatumLab101-4b Azure AD tenant, use the **Multi-Factor Authentication** link to open the **multi-factor authentication** portal. 

1. On the **multi-factor authentication** portal, display to the **service settings** tab, review its settings, and ensure that all **verification options**, including **Call to phone**, **Text message to phone**, **Notification through mobile app**, and **Verification code from mobile app or hardware token** are enabled.

1. On the **multi-factor authentication** portal, switch to the **users** tab, select **aaduser1** entry, and enable its multi-factor authentication status.

1. On the **multi-factor authentication** portal, note that the multi-factor authentication status of **aaduser1** changed to **Enabled** and that, once you select the user entry again, you have the option of changing it to **Enforced**.

   > **Note**: Changing the user status from enabled to enforced impacts only legacy, Azure AD integrated apps which do not support Azure MFA and, once the status changes to enforced, require the use of app passwords.

1. On the **multi-factor authentication** portal, with the **aaduser1** entry selected, display the **Manage user settings** window and review its options, including:

    - Require selected users to provide contact methods again

    - Delete all existing app passwords generated by the selected users

    - Restore multi-factor authentication on all remembered devices

1. Do not make any changes to user settings and switch back to the Azure portal. 

1. From the **Users - All users** blade of the AdatumLab101-4b Azure AD tenant, navigate to the **AdatumLab101-4b - Overview** blade.

1. From the **AdatumLab101-4b - Overview** blade, navigate to the **AdatumLab101-4b - MFA** blade.

1. From the **AdatumLab101-4b - MFA** blade, navigate to the **Multi-Factor Authentication - Fraud alert** blade and configure the following settings:

    - Allow users to submit fraud alerts: **On**

    - Automatically block users who report fraud: **On**

    - Code to report fraud during initial greeting: **0**


#### Task 6: Validate MFA configuration

1. Open an InPrivate Microsoft Edge window.

1. In the new browser window, navigate to the Azure portal and sign in using the **aaduser1** user account. When prompted, change the password to a new value.

   > **Note**: You will need to provide a fully qualified name of the **aaduser1** user account, including the Azure AD tenant DNS domain name, as noted earlier in this lab.

1. When prompted with the **More information required** message, continue to the **Additional security verification** page.

1. On the **How should we contact you?** page, note that you need to set up at least one of the following options:

    - **Authentication phone**

    - **Office phone**

    - **Mobile app**

1. Select the **Authentication phone** or **Office phone** option and select the **Call me** method of contact.

1. Complete the verification and note the automatically generated app password. 

1. When prompted, change the password from the one generated when you created the **aaduser1** account.

1. Verify that you successfully signed in to the Azure portal.

1. Sign out as **aaduser1** and close the InPrivate browser window.

1. Open an InPrivate Microsoft Edge window again, navigate to the Azure portal and, when prompted, sign in by using the **aaduser1** user account. This will automatically trigger the call to the phone number you provided.

1. Answer the call, press **0#**, and listen to the remainder of the message. 

   > **Note**: At this point, your account has been automatically blocked. 

1. To unblock the **aaduser1** account, sign in to the Azure portal by using the Microsoft account you used to create the **AdatumLab101-4b** Azure AD tenant, navigate to the **Multi-Factor Authentication - Block/unblock users** blade, and, use the **Unblock** link next to the **aaduser1** entry to unblock this user account. 

   > **Note**: To unblock a user, you need to provide **Reason for unblocking** on the **Unblock a user** blade. 


## Exercise 2: Implement Azure AD Identity Protection:
  
Estimated Time: 35 minutes

The main tasks for this exercise are as follows:

1. Enable Azure AD Identity Protection

1. Configure user risk policy

1. Configure sign-in risk policy

1. Validate Azure AD Identity Protection configuration by simulating risk events


#### Task 1: Enable Azure AD Identity Protection

1. From the lab virtual machine, start Microsoft Edge, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the Microsoft account you used to create the **AdatumLab101-4b** Azure AD tenant. 

   > **Note**: Ensure that you are signed-in to the **AdatumLab101-4b** Azure AD tenant. You can use the **Directory + subscription** filter to switch between Azure AD tenants. 

1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Azure AD Identity Protection**.

1. Select the **Azure AD Identity Protection** in the list of search results and proceed to create an instance of **Azure AD Identity Protection** associated with the **AdatumLab101-4b** Azure AD tenant.

1. In the Azure portal, navigate to the **All services** blade and use the search filter to display the **Azure AD Identity Protection** blade.


#### Task 2: Configure user risk policy

1. From the **Azure AD Identity Protection** blade, navigate to the **Azure AD Identity Protection - User risk policy** blade

1. On the **Azure AD Identity Protection - User risk policy** blade, configure the **User risk remediation policy** with the following settings:

    - Assignments: 

        - Users: **All users**

        - Conditions:

            - User risk: **Medium and above**

    - Controls:

        - Access: **Allow access**

        - **Require password change**

    - Enforce Policy: **On**


#### Task 3: Configure sign-in risk policy

1. From the **Azure AD Identity Protection - User risk policy** blade, navigate to the **Azure AD Identity Protection - Sign-in risk policy** blade

1. On the **Azure AD Identity Protection - Sign-in risk policy** blade, configure the **Sign-in risk remediation policy** with the following settings:

    - Assignments: 

        - Users: **All users**

        - Conditions:

            - User risk: **Medium and above**

    - Controls:

        - Access: **Allow access**

        - **Require multi-factor authentication**

    - Enforce Policy: **On**


#### Task 4: Validate Azure AD Identity Protection configuration by simulating risk events

   > **Note**: Before you start this task, ensure that the template deployment you started in Exercise 0 has completed. 

1. In the Azure portal, navigate to the **az1010401b-vm1** blade.

1. From the **az1010401b-vm1** blade, connect to the Azure VM via Remote Desktop session and, when prompted to sign in, provide the following credentials:

    - Admin Username: **Student**

    - Admin Password: **Pa55w.rd1234**

1. Within the Remote Desktop session, open an InPrivate Internet Explorer window.

1. In the new browser window, navigate to the ToR Browser Project at [**https://www.torproject.org/projects/torbrowser.html.en**](https://www.torproject.org/projects/torbrowser.html.en), download the ToR Browser, and install it with the default options.

1. Once the installation completes, start the ToR Browser, use the **Connect** option on the initial page, and navigate to the Application Access Panel at [**https://myapps.microsoft.com**](https://myapps.microsoft.com)

1. When prompted, sign in with the **aaduser2** account you created in the previous exercise.

1. You will be presented with the message **Your sign-in was blocked**. This is expected, since this account is not configured with multi-factor authentiation, which is required due to increased sign-in risk associated with the use of ToR Browser.

1. Use the **Sign out and sign in with a different account option** to sign in as **aaduser1** account you created and configured for multi-factor authentication in the previous exercise.

1. This time, you will be presented with the **Suspicious activity detected** message. Again, this is expected, since this account is configured with multi-factor authentiation. Considering the increased sign-in risk associated with the use of ToR Browser, you will have to use multi-factor authentication, according to the sign-in risk policy you configured in the previous task.

1. Use the **Verify** option and specify whether you want to verify your identity via text or a call. 

1. Complete the verification and ensure that you successfully signed in to the Application Access Panel.

1. Sign out as **aaduser1** and close the ToR Browser window.

1. Start Internet Explorer, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the Microsoft account you used to create the **AdatumLab101-4b** Azure AD tenant. 

1. In the Azure portal, navigate to the **Azure AD Identity Protection - Risk events** blade and note that the entry representing **Sign-in from anonymous IP address**.

1. From the **Azure AD Identity Protection - Risk events** blade, navigate to the **Azure AD Identity Protection - Users flagged for risk** blade and note the entry representing **aaduser2**.

> **Result**: After you completed this exercise, you have enabled Azure AD Identity Protection, configured user risk policy and sign-in risk policy, as well as validated Azure AD Identity Protection configuration by simulating risk events