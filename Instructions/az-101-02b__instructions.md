# AZ 101 Module 2 - Implement and Manage Application Services
# Lab 2: Monitor changes to Azure resources by using Azure Event Grid and Azure Logic Apps

Estimated Time: 90 minutes

All tasks in this lab are performed from the Azure portal (including a PowerShell Cloud Shell session)  

   > **Note**: When not using Cloud Shell, the lab virtual machine must have the Azure PowerShell 1.2.0 module (or newer) installed [https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0)

Lab files: none   

### Scenario
  
Adatum Corporation wants to monitor changes to Azure resources by using Azure serverless services


### Objectives
  
After completing this lab, you will be able to:

-  Implement serverless services in Azure

-  Configure Azure Logic App and Event Grid to facilitate event monitoring


## Exercise 1: Implement prerequisites of the monitoring solution
  
Estimated Time: 40 minutes

The main tasks for this exercise are as follows:

1. Create an Azure Storage account

1. Create an Azure Logic App

1. Create an Azure AD service principal

1. Configure RBAC-based permissions

1. Register the Event Grid resource provider

  
#### Task 1: Create an Azure Storage account

1. From the lab virtual machine, start Microsoft Edge and browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the Microsoft account that has the Owner role in the target Azure subscription.
  
1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Storage account**.

1. Use the search results to navigate to the **Create storage account** blade.

1. On the **Basic** tab of the **Create storage account** blade, configure the following settings:

    - Subscription: the name of the subscription you intend to use in this lab

    - Resource group: the name of a new resource group **az1010201b-RG**

    - Storage account name: any valid, unique name between 3 and 24 characters consisting of lowercase letters and digits

    - Location: the name of the Azure region which is closest to the lab location and where you can provision Azure resources

    - Performance: **Standard**

    - Account kind: **Storage (general purpose v1)**

    - Replication: **Locally-redundant storage (LRS)**

1. From the **Basic** tab of the **Create storage account** blade, switch to the **Advanced** tab and configure the following settings:

    - Secure transfer required: **Enabled**

    - VIRTUAL NETWORKS: 

        - Allow access from: **All networks**

    - DATA LAKE STORAGE GEN2: 

        - Hierarchical namespace: **Disabled**

1. From the **Advanced** tab of the **Create storage account** blade, switch to the **Review + create** tab and initiate creation of the storage account. 

    > **Note**: Do not wait for the storage acocunt to be created but instead proceed to the next task. 


#### Task 2: Create an Azure Logic App

1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Logic App**.

1. Use the search results to navigate to the **Logic App Create** blade and create an instance of Logic App with the following settings:

    - Name: **logicappaz1010201b**

    - Subscription: the name of the Azure subscription you are using in this lab

    - Resource group: the name of a new resource group **az1010202b-RG**

    - Location: the same Azure region into which you deployed the storage account in the previous task

    - Log Analytics: **Off**

1. Wait until the logic app is provisioned. This will take about a minute. 


#### Task 3: Create an Azure AD service principal

1. From the Azure Portal, start a PowerShell session in the Cloud Shell. 

   > **Note**: If this is the first time you are launching the Cloud Shell in the current Azure subscription, you will be asked to create an Azure file share to persist Cloud Shell files. If so, accept the defaults, which will result in creation of a storage account in an automatically generated resource group.

1. In the Cloud Shell pane, run the following commands to create a new Azure AD application that you will associate with the service principal you create in the subsequent steps of this task:

   ```
   $password = 'Pa55w.rd1234'

   $securePassword = ConvertTo-SecureString -Force -AsPlainText -String $password

   $aadApp1010201b = New-AzADApplication -DisplayName 'aadApp1010201b' -HomePage 'http://aadApp1010201b' -IdentifierUris 'http://aadApp1010201b' -Password $securePassword
   ```

1. From the Cloud Shell pane, run the following command to create a new Azure AD service principal associated with the application you created in the previous step:

   ```
   New-AzADServicePrincipal -ApplicationId $aadApp1010201b.ApplicationId.Guid
   ```

1. In the output of the **New-AzureRmADServicePrincipal** cmdlet, note the value of the **ApplicationId** property. You will need this in the next exercise of this lab.

1. From the Cloud Shell pane, run the following cmdlet to identify the value of the **Id** property of the current Azure subscription and the value of the **TenantId** property of the Azure AD tenant associated with that subscription (you will also need them in the next exercise of this lab):

   ```
   Get-AzSubscription
   ```

1. Close the Cloud Shell pane.


#### Task 4: Configure RBAC-based permissions

1. In the Azure portal, navigate to the blade displaying properties of your Azure subscription. 

1. From the Azure subscription blade, navigate to its **Access control (IAM)** blade.

1. From the **Access control (IAM)** blade, navigate to the **Add role assignment** blade. 

1. From the **Add role assignment** blade, assign the **Reader** role within the scope of the Azure subscription to the **aadApp1010201b** service principal.


#### Task 5: Register the Event Grid resource provider

1. In the Azure portal, in the Microsoft Edge window, reopen the **PowerShell** session within the **Cloud Shell**. 

1. From the Cloud Shell pane, run the following command to register the Microsoft.EventGrid resource provider:

   ```
   Register-AzResourceProvider -ProviderNamespace Microsoft.EventGrid
   ```

1. Close the Cloud Shell pane.

> **Result**: After you completed this exercise, you have created a storage account, a logic app that you will configure in the next exercise of this lab, an Azure AD service principal that you will reference during that configuration, assigned to that service principal the Reader role within the Azure subscription, and registered the Event Grid resource provider.


## Exercise 2: Configure Azure Logic App and Event Grid

Estimated Time: 50 minutes

The main tasks for this exercise are as follows:

1. Add an Event Grid-based trigger to the Azure Logic App

1. Add an action to the Azure Logic App

1. Configure event subscription

1. Validate the functionality of the Azure Logic App


#### Task 1: Add an Event Grid-based trigger to the Azure Logic App

1. In the the Azure portal, navigate to the blade of the newly provisioned Azure logic app.

1. From the blade of the newly provisioned Azure logic app, navigate to its **Logic App Designer** blade.

1. From the **Logic App Designer** blade, use the **Blank Logic App** option to navigate to the blank designer workspace. 

1. On the **Logic App Designer** workspace blade, display the list of connectors and triggers that can be added to the workspace.

1. Use the **Search connectors and triggers** text box to locate the **Event Grid** triggers and, from the list of results, add the **When a resource event occurs (preview) Azure Event Grid** trigger to the designer workspace.

1. On the **Azure Event Grid** tile, use the **Connect with Service Principal** link and specify the following values:

    - Connection Name: **egcaz1010201b**

    - Client ID: the **ApplicationId** property you identified in the previous exercise

    - Client Secret: **Pa55w.rd1234**

    - Tenant: the **TenantId** property you identified in the previous exercise

1. On the **When a resource event occurs** tile, specify the following values to configure the new connection:

    - Subscription: use the **Enter custom value** option to enter the subscription **Id** property you identified in the previous exercise

    - Resource Type: **Microsoft.Resources.resourceGroups**

    - Resource Name: use the **Enter custom value** option to enter **/subscriptions/*subscriptionId*/resourceGroups/az1010201b-RG**, where ***subscriptionId*** is the subscription **Id** property you identified in the previous exercise

    - Event Type Item - 1: **Microsoft.Resources.ResourceWriteSuccess**

    - Event Type Item - 2: **Microsoft.Resources.ResourceDeleteSuccess**


#### Task 2: Add an action to the Azure Logic App

1. In the the Azure portal, on the **Logic App Designer** blade of the newly provisioned Azure logic app, use the **+ New step** option to display the **Choose an action** pane.

1. In the **Choose an action** pane, use the **Search connectors and actions** text box to select the **Outlook.com** and its **Send an email** action.

1. In the **Outlook.com** pane, select the **Sign in** button and, when prompted, provide the credentials of the Microsoft Account you are using in this lab. 

1. When prompted for the consent, grant Azure Logic App permissions to access Outlook resources.

1. In the **Send an email** pane, specify the following settings:

    - To: the name of your Microsoft Account

    - Subject: **Resource updated:** followed by the **Subject** **Dynamic Content** entry.

    - Body: the **Topic** **Dynamic Content** entry, followed by **Event type** **Dynamic Content** entry, followed by **ID** **Dynamic Content** entry, followed by the **Event Time** **Dynamic Content** entry.

1. Save the changes you made on the **Logic App Designer** blade.


#### Task 3: Configure event subscription

   > **Note**: In order to configure event subscription, you need to first identify the callback URL of the Azure logic app

1. In the Azure portal, navigate back to the **logicappaz1010201b** blade and, in the **Summary** section, click **See trigger history**.

1. On the **When_a_resource_event_occurs** blade, copy the value of the **Callback url [POST]** text box into Clipboard.

   > **Note**: Once you identified the callback URL, you can proceed to configure event subscription.

1. In the Azure portal, navigate to the **az1010201b-RG** resource group and display its **Events** blade.

1. On the **az1010201b-RG - Events** blade, use the **Web Hook** option to navigate to the **Create Event Subscription** blade.

1. On the **Create Event Subscription** blade, clear the **Subscribe to all event types** checkbox and, in the **Defined Event Types** drop down list, ensure that only the checkboxes next to the **Resource Write Success** and **Resource Delete Success** are selected.

1. In the **ENDPOINT DETAILS** section, in the **Endpoint type** drop-down list, select the **Web Hook** option and use the **Select an endpoint** link to display the **Select Web Hook** blade.  

1. On the **Select Web Hook** blade, in the **Subscriber Endpoint**, paste the value of the **Callback url [POST]** of the Azure logic app you copied in the previous task and confirm the selection.

1. Set the **Name** in the **EVENT SUBSCRIPTION DETAILS** section to **event-subscription-az1010201b**.

1. Use the **Create** button to finalize your settings.


#### Task 4: Validate the functionality of the Azure Logic App

1. In the Azure portal, navigate to the **az1010201b-RG** resource group and, in the list of its resources, locate the Azure storage account you created in the first exercise.

1. Navigate to the storage account blade, from its **Configuration** blade, set the **Secure transfer required** setting to **Disabled**, and save the change.

1. Navigate to the **logicappaz1010201b** blade and note that the **Runs history** includes the entry corresponding to configuration change of the Azure storage account.

1. Navigate to the inbox of the email account of the Microsoft account you used in this exercise and verify that includes an email generated by the logic app.

> **Result**: After you completed this exercise, you have configured an Azure logic app to monitor changes to a resource group by adding an Event Grid-based trigger to the Azure Logic App, adding an action to the Azure Logic App, and configuring an event subscription. You also validated the functionality of the newly configured Azure Logic App.

