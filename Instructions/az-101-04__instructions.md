# AZ 101 Module 4 - Secure Identities
# Lab: Secure Identities

Estimated Time: 60 minutes

All tasks in this lab are performed from the Azure portal (including a PowerShell Cloud Shell session) 

   > **Note**: When not using Cloud Shell, the lab virtual machine must have Azure AD PowerShell module installed [**https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0**](https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0)

   > **Note**: Exercise 3 and Exercise 4 of this lab require the use of a mobile phone


Lab files: 

-  **Labfiles\\AZ101\\Mod04\\az-101-04_01_azuredeploy.json**

-  **Labfiles\\AZ101\\Mod04\\az-101-04_01_azuredeploy.parameters.json**

-  **Labfiles\\AZ101\\Mod04\\az-101-04_01_customRoleDefinition.json**

### Scenario
  
Adatum Corporation wants to leverage Azure Active Directory (AD) capabilities to delegate management of its resources and identities. It also wants to take advantage of more advanced capabilities available in Azure AD Premium P2.


### Objectives
  
After completing this lab, you will be able to:

-  Deploy an Azure VM by using an Azure Resource Manager template

-  Create Azure AD users and groups

-  Delegate management of Azure resources by using custom Role-Based Access Control (RBAC) roles

-  Delegate management of Azure AD by using Privileged Identity Management directory roles

-  Delegate management of Azure resources by using Privileged Identity Management resource roles


## Exercise 0: Deploy an Azure VM by using an Azure Resource Manager template
  
Estimated Time: 5 minutes

The main tasks for this exercise are as follows:

1. Deploy an Azure VM running Windows Server 2016 Datacenter by using an Azure Resource Manager template


#### Task 1: Deploy an Azure VM running Windows Server 2016 Datacenter by using an Azure Resource Manager template

1. From the lab virtual machine, start Microsoft Edge, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the Microsoft account that has the Owner role in the Azure subscription you intend to use in this lab and is a Global Administrator of the Azure AD tenant associated with that subscription.

1. In the Azure portal, navigate to the **Create a resource** blade.

1. From the **Create a resource** blade, search Azure Marketplace for **Template deployment**.

1. Use the list of search results to navigate to the **Deploy a custom template** blade.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, load the template file **Labfiles\\AZ101\\Mod04\\az-101-04_01_azuredeploy.json**. 

   > **Note**: Review the content of the template and note that it defines deployment of an Azure VM hosting Linux Ubuntu.

1. Save the template and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, navigate to the **Edit parameters** blade.

1. From the **Edit parameters** blade, load the parameters file **Labfiles\\AZ101\\Mod04\\az-101-04_01_azuredeploy.parameters.json**. 

1. Save the parameters and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, initiate a template deployment with the following settings:

    - Subscription: the name of the subscription you intend to use in this lab

    - Resource group: the name of a new resource group **az1010401-RG**

    - Location: the name of the Azure region which is closest to the lab location and where you can provision Azure VMs

    - Admin Username: **Student**

    - Admin Password: **Pa55w.rd1234**

    - Ubuntu OS Version: **16.04.0-LTS**

   > **Note**: To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

   > **Note**: Do not wait for the deployment to complete but proceed to the next task. You will use the Azure VM provisioned by this deployment in Exercise 2 Task 3.


## Exercise 1: Create Azure AD users and groups

Estimated Time: 10 minutes

The main tasks for this exercise are as follows:

1. Create an Azure AD user

1. Create an Azure AD security group and add the Azure AD user to the group.


#### Task 1: Create an Azure AD user

1. From the Azure Portal, start a PowerShell session in the Cloud Shell pane.

   > **Note**: If this is the first time you are launching the Cloud Shell in the current Azure subscription, you will be asked to create an Azure file share to persist Cloud Shell files. If so, accept the defaults, which will result in creation of a storage account in an automatically generated resource group.

1. In the Cloud Shell pane, run the following commands:

   ```
   $domainName = ((Get-AzureAdTenantDetail).VerifiedDomains)[0].Name
   $domainName
   ```

   > **Note**: These commands identify the verified DNS name of the Azure AD tenant associated with the Azure subscription you are using in this lab. Take a note of this value since you will need it later in this lab.

1. In the Cloud Shell pane, run the following commands:

   ```
   $passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
   $passwordProfile.Password = 'Pa55w.rd1234'
   $passwordProfile.ForceChangePasswordNextLogin = $false
   $aadUser = New-AzureADUser -AccountEnabled $true -DisplayName 'aaduser 101041' -PasswordProfile $passwordProfile -MailNickName 'aaduser101041' -UserPrincipalName "aaduser101041@$domainName"
   ```

   > **Note**: These commands create an Azure AD user which you will use later in this lab.

1. In the Cloud Shell pane, run the following command:

   ```
   (Get-AzureADUser -Filter "MailNickName eq 'aaduser101041'").UserPrincipalName
   ```

   > **Note**: This command identifies the user principal name of the newly created Azure AD user. Take a note of this name. You will use it later in this lab.


#### Task 2: Create an Azure AD security group and add the Azure AD user to the group.

1. In the Cloud Shell pane, run the following command:

   ```
   $aadGroup = New-AzureADGroup -Description "VM Operators" -DisplayName "VM Operators" -MailEnabled $false -SecurityEnabled $true -MailNickName "VM-Operators"
   ```

   > **Note**: This command creates an Azure AD security group

1. In the Cloud Shell pane, run the following command:

   ```
   Add-AzureADGroupMember -ObjectId $aadGroup.ObjectId -RefObjectId $aadUser.ObjectId
   ```

   > **Note**: This command adds the user you created in the previous task to the newly created Azure AD group

1. In the Cloud Shell pane, run the following command:

   ```
   Get-AzureADGroupMember -ObjectId $aadGroup.ObjectId
   ```

   > **Note**: This command returns the list of members of the newly created Azure AD group


1. Close the Cloud Shell pane.


## Exercise 2: Delegate management of Azure resources by using custom Role-Based Access Control roles
  
Estimated Time: 15 minutes

The main tasks for this exercise are as follows:

1. Identify actions to delegate via RBAC

1. Create a custom RBAC role in the Azure AD tenant

1. Assign the custom RBAC role and test the role assignment


#### Task 1: Identify actions to delegate via RBAC

1. In the Azure portal, navigate to the blade of the resource group **az1010401-RG**.

1. From the **az1010401-RG** blade, display its **Access Control (IAM)** blade.

1. From the **az1010401-RG - Access Control (IAM)** blade, display the **Roles** blade.

1. From the **Roles** blade, display the **Owner** blade.

1. From the **Owner** blade, display the **Permissions (preview)** blade.

1. From the **Permissions (preview)** blade, display the **Microsoft Compute** blade.

1. From the **Microsoft Compute** blade, display the **Virtual Machines** blade.

1. On the **Virtual Machines** blade, review the list of management actions that can be delegated through RBAC. Note that they include the **Deallocate Virtual Machine** and **Start Virtual Machine** actions.


#### Task 2: Create a custom RBAC role in the Azure AD tenant

1. On the lab virtual machine, open the file **Labfiles\\AZ101\\Mod04\\az-101-04_01_custom.role.definition.json** and review its content:

   ```
   {
      "Name": "Virtual Machine Operator (Custom)",
      "Id": null,
      "IsCustom": true,
      "Description": "Allows to start and stop (deallocate) Azure VMs",
      "Actions": [
          "Microsoft.Compute/*/read",
          "Microsoft.Compute/virtualMachines/deallocate/action",
          "Microsoft.Compute/virtualMachines/start/action"
      ],
      "NotActions": [
      ],
      "AssignableScopes": [
          "/subscriptions/SUBSCRIPTION_ID"
      ]
   }
   ```

1. From the Azure Portal, start a PowerShell session in the Cloud Shell. 

1. From the Cloud Shell pane, upload the file **Labfiles\\AZ101\\Mod04\\az-101-04_01_custom.role.definition.json** into the home directory.

1. In the Cloud Shell pane, run the following commands:

   ```
   $subscription_id = (Get-AzureRmSubscription).Id
   (Get-Content -Path $HOME/az-101-04_01_custom.role.definition.json) -Replace 'SUBSCRIPTION_ID', "$subscription_id" | Set-Content -Path $HOME/az-101-04_01_custom.role.definition.json
   ```

   > **Note**: These commands replace the **SUBSCRIPTION\_ID** placeholder with the actual Id of the Azure subscription you are using in this lab.
 
1. From the Cloud Shell pane, run the following command: 

   ```
   New-AzureRmRoleDefinition -InputFile $HOME/az-101-04_01_custom.role.definition.json
   ```

   > **Note**: This command creates the custom role definition object in the Azure AD tenant by using the JSON file you uploaded to the Cloud Shell

1. From the Cloud Shell pane, run the following command:

   ```
   Get-AzureRmRoleDefinition -Name 'Virtual Machine Operator (Custom)'
   ```

   > **Note**: This command verifies that the role has been successfully defined by retrieving the role definition object and displaying its properties

1. Close the Cloud Shell pane.


#### Task 3: Assign the custom RBAC role and test the role assignment

   > **Note**: Before you test the custom RBAC role assignment this task, ensure that the template deployment you started in Exercise 0 has completed. 

1. In the Azure portal, navigate to the blade of the resource group **az1010401-RG**.

1. From the **az1010401-RG** blade, display its **Access Control (IAM)** blade.

1. From the **az1010401-RG - Access Control (IAM)** blade, display the **Add permissions** pane.

1. From the **Add permissions** pane, assign the custom RBAC role to the Azure AD security group **VM Operators** you created in the previous exercise by using the following settings:

    - Role: **Virtual Machine Operator (Custom)**

    - Assign access to: **Azure AD user, group, or application**

    - Select: **VM Operators**

1. Launch another Microsoft Edge window in the InPrivate mode, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the **aaduser101041** user account:

    - Username: the user principal name of the Azure AD user **aaduser101041** you identified in the first exercise of this lab.

    - Password: **Pa55w.rd1234**

1. In the Azure portal, navigate to the **Resource groups** blade. Note that you are not able to see any resource groups. 

1. In the Azure portal, navigate to the **All resources** blade. Note that you are able to see only the **az1010401-vm** and its managed disk.

1. In the Azure portal, navigate to the **az1010401-vm** blade. 

1. Try restarting the virtual machine. Review the error message in the notification area and note that this action failed because the current user is not authorized to carry it out.

1. Stop the virtual machine and verify that the action completed successfully.

1. Start the virtual machine and verify that the action completed successfully.

1. Sign out as the Azure AD user **aaduser101041** and close the Microosft Edge InPrivate mode window.

> **Result**: After you completed this exercise, you have defined, assigned, and tested a custom RBAC role


## Exercise 3: Delegate management of Azure AD by using Privileged Identity Management directory roles

Estimated Time: 15 minutes
  
The main tasks for this exercise are as follows:

1. Activate Azure AD Premium P2 trial

1. Assign Azure AD Premium P2 licenses

1. Activate Privileged Identity Management

1. Sign up PIM for Azure AD roles

1. Delegate management of Azure AD roles

1. Validate delegation of management of Azure AD roles


#### Task 1: Activate Azure AD Premium P2 trial.

   > **Note**: In order to use Azure AD Privileged Identity Management, you need to have Azure AD Premium 2 licenses

1. In the Azure portal, while signed in by using the Microsoft account that has the Owner role in the Azure subscription and is a Global Administrator of the Azure AD tenant associated with that subscription, navigate to the Azure AD tenant blade.

1. From the Azure AD tenant blade, navigate to the **Licenses** blade. 

1. From the the **Licenses** blade, navigate to the **Licenses - All products** blade.

1. From the **Licenses - All products** blade, navigate to the **Activate** blade and activate the **Azure AD Premium P2** trial.


#### Task 2: Assign Azure AD Premium P2 licenses.

1. Navigate to the **Users - All users** blade of the Azure AD tenant associated with your Azure subscription. 

1. From the **Users - All users** blade, display the **aaduser 101041 - Profile** blade. 

1. From the **aaduser 101041 - Profile** blade, edit **Settings** of the **aaduser 101041** user account by selecting the **Usage location** matching the location of the Azure AD tenant.

1. Navigate back to the **Licenses - Overview** blade of the Azure AD tenant associated with your Azure subscription.

1. From the **Licenses - Overview** blade, navigate to the **Products** blade. 

1. From the **Products** blade, navigate to the **Azure Active Directory Premium P2 - Licensed users** blade. 

1. From the **Azure Active Directory Premium P2 - Licensed users**, navigate to the **Assign license** blade.

1. From the **Assign license** blade, assign an Azure AD Premium P2 license to the **aaduser 101041** user account.


#### Task 3: Activate Privileged Identity Management

1. In the Azure portal, navigate to the **Privileged Identity Management** blade.

1. From the **Privileged Identity Management** blade, initiate the **Consent to PIM** action.

1. From the **Privileged Identity Management - Consent to PIM** blade, proceed to the **Verify my identity** task. 

1. On the **Aditional security verification** page, specify the following settings:

    - **Step 1: How should we contact you?**

        - Authentication phone: select your country or region and specify a mobile phone number you intend to use in this lab

        - Method: **Send me a code by text message**

    - **Step 2: We've send a text message to your phone**

        - Use the code in the text message you received

1. Back on the **Privileged Identity Management** blade, grant consent and, when prompted, confirm your decision.


#### Task 4: Sign up PIM for Azure AD roles

1. In the Azure portal, from the **Privileged Identity Management - Quick start** blade, navigate to the **Azure AD roles - Quick start** blade. 

1. From the **Azure AD roles - Quick start** blade, navigate to the **Azure AD roles - Sign up PIM for Azure AD Roles** blade.

1. From the **Azure AD roles - Sign up PIM for Azure AD Roles** blade, sign up for Azur eAD PIM for Azure AD roles.


#### Task 5: Delegate management of Azure AD roles

1. In the Azure portal, return to the **Privileged Identity Management - Quick start** blade and then navigate to the **Azure AD roles - Quick start** blade.

   > **Note**: This step allows you to access the Azure AD roles management features in the portal.

1. From the **Azure AD roles - Quick start** blade, display the **Azure AD roles - Roles** blade.

1. From the **Azure AD roles - Roles** blade, display the **Add managed members** blade. 

1. From the **Add managed members** blade, specify the following settings in order to designate the **aaduser101041** user account as an eligible member of the **User Administrator** role:

    - Select a role: **User Administrator**

    - Select members: **aaduser 101041**

1. From the **Azure AD roles - Roles** blade, display the **Azure AD roles - Members** blade and note that the **aaduser101041** user account is listed as an eligible member of the **User Administrator** role.


#### Task 6: Validate delegation of management of Azure AD roles

1. Launch another Microsoft Edge window in the InPrivate mode, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the **aaduser101041** user account:

    - Username: the user principal name of the Azure AD user **aaduser101041** you identified in the first exercise of this lab.

    - Password: **Pa55w.rd1234**

1. In the Azure portal, navigate to the **Privileged Identity Management - Quick start** blade. 

1. From the **Privileged Identity Management - Quick start** blade, display the **My roles - Azure AD roles** blade.

1. On the **My roles - Azure AD roles** blade, on the **Eligible roles** tab, note that you are eligible to activate the assignment to the **User Administrator** role. 

1. From the **My roles - Azure AD roles** blade, initiate the activation. This will display the **User Administrator** blade.

1. From the **User Administrator** blade, proceed to the **Verify my identity** task. 

1. On the **Aditional security verification** page, specify the following settings:

    - **Step 1: How should we contact you?**

        - Authentication phone: select your country or region and specify a mobile phone number you intend to use in this lab

        - Method: **Send me a code by text message**

    - **Step 2: We've send a text message to your phone**

        - Use the code in the text message you received

1. Back on the **User Administrator** blade, initiate activation. This will display the **Activation** blade.

1. From the the **Activation** blade, perform activation using the following settings:

    - Activation duration (hours): **1**

    - Activation reason: **testing PIM-based Azure AD role delegation**

1. In the Azure portal, navigate back to the **My roles - Azure AD roles** blade.

1. On the **My roles - Azure AD roles** blade, on the **Active roles** tab, note that the role assignment has been activated. 

1. In the Azure portal, navigate to the **Users - All users** blade of the Azure AD tenant associated with your Azure subscription.

1. From the **Users - All users** blade, create a new Azure AD user account with the following settings:

    - Name: **aaduser101042**

    - User name: **aaduser101042@***<DNS-domain-name>* where *<DNS-domain-name>* represents the primary DNS domain name you identified in the first exercise of this lab.

    - Profile: **Not configured**

    - Properties: **Default**

    - Groups: **0 groups selected**

    - Directory role: **User**

    - Password: accept the default vaule.

1. Verify that the user was created successfully.

1. Sign out as the Azure AD user **aaduser101041** and close the Microosft Edge InPrivate mode window.

> **Result**: After you completed this exercise, you have activated Azure AD Premium P2 trial, assigned Azure AD Premium P2 licenses, activated Privileged Identity Management, signed up PIM for Azure AD roles, delegated management of Azure AD roles, and validated delegation of management of Azure AD roles.


## Exercise 4: Delegate management of Azure resources by using Privileged Identity Management resource roles

Estimated Time: 15 minutes

The main tasks for this exercise are as follows:

1. Onboard the Azure subscription for PIM resource management

1. Delegate management of Azure AD resources

1. Validate delegation of management of Azure AD resources


#### Task 1: Onboard the Azure subscription for PIM resource management

1. In the Azure portal, while signed in by using the Microsoft account that has the Owner role in the Azure subscription and is a Global Administrator of the Azure AD tenant associated with that subscription, navigate to the **Privileged Identity Management - Quick start** blade.

1. From the **Privileged Identity Management - Quick start** blade, navigate to the **Privileged Identity Management - Azure resources** blade. 

1. From the **Privileged Identity Management - Azure resources** blade, display the **Azure resources - Discovery** blade.

1. On the **Privileged Identity Management - Azure resources** blade, select the entry representing your Azure subscription and initiate the resource management action. When prompted, confirm your decision to onboard selected resource for management. 


#### Task 2: Delegate management of Azure AD resources

1. Navigate back to the **Privileged Identity Management - Azure resources** blade and note that that your Azure subscription is listed as the discovered resource.

1. From the **Privileged Identity Management - Azure resources** blade, select the entry representing your Azure subscription. This will automatically display the blade representing Privileged Identity Management resource settings for this subscription.

1. From the blade representing Privileged Identity Management resource settings for your Azure subscription, display the list of resource roles.

1. From the blade listing resource roles, display the **Contributor** blade.

1. From the **Contributor** blade, display the **New assignment** blade. 

1. From the **New assignment** blade, specify the following settings in order to designate the **aaduser101041** user account as an eligible member of the **Contributor** role:

    - Select a role: **Contributor**

    - Select a member or group: **aaduser 101041**

    - Set membership settings: 

        - Assignment type: **Eligible**

        - Assignment starts: select current date and time

        - Assignment ends: select the date and time 24 hours ahead of the current date and time

1. From the blade representing Privileged Identity Management resource settings for your Azure subscription, display the **Members** blade and, on the **Eligible roles** tab, note that the **aaduser101041** user account is listed as member of the **Contributor** role.


#### Task 3: Validate delegation of management of Azure resources

1. Launch another Microsoft Edge window in the InPrivate mode, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the **aaduser101041** user account:

    - Username: the user principal name of the Azure user **aaduser101041** you identified in the first exercise of this lab

    - Password: **Pa55w.rd1234**

1. In the Azure portal, navigate to the **Privileged Identity Management - Azure resources** blade. 

1. From the **Privileged Identity Management - Azure resources** blade, select the entry representing your Azure subscription. This will automatically display the blade representing Privileged Identity Management resource settings for this subscription.

1. On the blade representing Privileged Identity Management resource settings for this subscription, note the message indicating that you have eligible roles that can be activated.

1. From the blade representing Privileged Identity Management resource settings for this subscription, navigate to the **My roles** blade.

1. On the **My roles** blade, on the **Eligible resources** tab, note that you are eligible to activate the assignment to the **Contributor** role. 

1. From the **My roles** blade, initiate the activation. This will display the **Activate** blade.

1. From the the **Activate** blade, perform activation using the following settings:

    - Scope: the name of your Azure subscription

    - Start time: current date and time

    - Duration (hours): **8**

    - Reason: **testing PIM-based Azure resource role delegation**

1. Back on the **My roles** blade, refresh the page and display the **Active roles** tab. Note that the role assignment has been activated. 

1. Sign out as the Azure user **aaduser101041** and then sign back in.

1. In the Azure portal, navigate to the **All resources** blade and note that you are able to see all Azure resources in your Azure subscription.

1. In the Azure portal, navigate to the **Subscriptions** blade and select the entry representing your Azure subscription.

1. From the blade displaying properties of your Azure subscription, navigate to its **Access control (IAM)** blade. 

1. On the **Access control (IAM)** blade, note that the **aaduser101041** user account is listed as a member of the **Contributor** role.

1. Sign out as the Azure user **aaduser101041** and close the Microosft Edge InPrivate mode window.

> **Result**: After you completed this exercise, you have onboarded the Azure subscription for PIM resource management, delegated management of Azure AD resources, and validate delegation of management of Azure AD resources.
