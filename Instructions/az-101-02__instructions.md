# AZ 101 Module 2 - Implement and Manage Application Services
# Lab: Implement and Manage Azure Web Apps

Estimated Time: 45 minutes

All tasks in this lab are performed from the Azure portal (including a PowerShell Cloud Shell session)

   > **Note**: When not using Cloud Shell, the lab virtual machine must have Git installed [**https://git-scm.com/download/win**](https://git-scm.com/download/win)

Lab files: none   

### Scenario
  
Adatum Corporation wants to implement Azure web apps and configure them for scalability and performance


### Objectives
  
After completing this lab, you will be able to:

-  Implement Azure web apps

-  Manage scalability and performance of Azure web apps


## Exercise 1: Implement Azure web apps
  
Estimated Time: 20 minutes

The main tasks for this exercise are as follows:

1. Create an Azure web app

1. Configure web app deployment settings. 

1. Create a staging deployment slot

1. Deploy code to the staging deployment slot and perform slot swap

  
#### Task 1: Create an Azure web app

1. From the lab virtual machine, start Microsoft Edge, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using a Microsoft account that has the Owner role in the Azure subscription you intend to use in this lab.

1. In the Azure portal, navigate to the **Create a resource** blade.

1. From the **Create a resource** blade, search Azure Marketplace for **Web app**.

1. Use the list of search results to navigate to the **Web App Create** blade.

1. From the **Web App Create** blade, create a new web app with the following settings:

    - App name: any unique, valid name 

    - Subscription: the name of the Azure subscription you intend to use in this lab

    - Resource group: the name of a new resource group **az1010201-RG**

    - OS: **Windows**

    - Publish: **Code**

    - App Service plan/Location: a new App Service plan with the following settings:

        - Name: **az1010201-AppServicePlan1**

        - Location: the name of an Azure region where you can provision Azure web apps

        - Pricing tier: **S1 Standard**

    - Application Insights: **Off**

   > **Note**: The green check mark in the **App name** text box will indicate whether the name you typed in is valid and unique. 

   > **Note**: To identify Azure regions where you can provision Azure web apps, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

   > **Note**: Wait until the web app is created before you proceed to the next task. This should take about a minute.


#### Task 2: Create a staging deployment slot

1. In the Azure portal, navigate to the blade of the newly provisioned web app. 

1. On the web app blade, use the **Browse** toolbar icon to open a new browser tab displaying the default App Service home page.

1. Close the browser tab displaying the default App Service home page.

1. In the Azure portal, from the web app blade, display its **Deployment slots** blade.

1. From the **Deployment slots** blade, add a slot with the following settings:

    - Name: **staging**

    - Configuration Source: **Don't clone configuration from an existing slot**

1. From the **Deployment slots** blade, navigate to the **staging** blade displaying the properties of the newly created deployment slot.

1. On the **staging** blade, use the **Browse** toolbar icon to open a new browser tab displaying the default App Service home page.

1. Close the browser tab displaying the default App Service home page in the staging deployment slot.


#### Task 3: Configure web app deployment settings. 

1. In the Azure portal, from the **staging blade**, display the **staging - Deployment Center** blade.

1. On the **staging - Deployment Center** blade, configure the following settings:

    - Source control: **Local Git**

    - Build provider: **App Service Kudu build server**

1. Note the resulting **Git Clone Url**. You will need in the next task of this exercise.

1. From the **Deployment Center** blade, use the **Deployment Credentials** toolbar icon to display **User Credentials** pane. 

1. In the **User Credentials** pane, set the password to **Pa55w.rd1234** and save the newly set credentials.


#### Task 4: Deploy code to the staging deployment slot and perform a slot swap

1. From the Azure Portal, start a PowerShell session in the Cloud Shell pane. 

   > **Note**:  If this is the first time you are launching the Cloud Shell in the current Azure subscription, you will be asked to create an Azure file share to persist Cloud Shell files. If so, accept the defaults, which will result in creation of a storage account in an automatically generated resource group.

1. In the Cloud Shell pane, run the following command:

   ```
   git clone https://github.com/Azure-Samples/php-docs-hello-world
   ```

   > **Note**: This command clones a remote repository containing a sample web app code

1. In the Cloud Shell pane, run the following command:

   ```
   Set-Location -Path $HOME/php-docs-hello-world/
   ```

   > **Note**: This command sets the current location to the newly created clone of the local repository containing the sample web app code

1. In the Cloud Shell pane, run the following command, replacing the `<git_clone_url>` placeholder with the value of the **Git Clone Url** you identified in the previous task:

   ```
   git remote add azure <git_clone_url>
   ```

   > **Note**: This command connects the local repo to the Git repo in Azure repos associated with the Azure web app

1. In the Cloud Shell pane, run the following command:

   ```
   git push azure master
   ```

   > **Note**: This command pushes the sample web app code from the local repository to the Azure web app staging deployment slot

1. When prompted, type the password **Pa55w.rd1234** you set in the previous task.

1. Close the Cloud Shell pane.

1. In the Azure portal, navigate to the **Overview** section of the **staging** blade. 

1. On the **staging** blade, use the **Browse** toolbar icon to open a new browser tab. Note that the browser displays the **Hello World!** page you just deployed.

1. Close the browser tab displaying the **Hello World!** page.

1. On the **staging** blade, use the **Swap** toolbar icon to display the **Swap** blade.

1. On the **Swap** blade, initiate slot swap with the following settings:

    - Swap type: **swap**

    - Source: **staging**

    - Destination: **production**

    - Preview Changes: review the changes that will be applied to the destination slot

1. On the **staging** blade, use the **Browse** toolbar icon to open a new browser tab. Note that the browser displays now the default App Service home page.

1. Close the browser tab displaying the default App Service home page.

1. From the **staging** blade, display its **Deployment slots** blade.

1. From the **Deployment slots** blade, navigate back to the blade displaying the properties of the production slot of the Azure web app.

1. On the web app blade, use the **Browse** toolbar icon to open a new browser tab. Note that the browser displays the **Hello World!** page.

1. Close the browser tab displaying the **Hello World!** page.

> **Result**: After you completed this exercise, you have created an Azure web app, configured web app deployment settings, created a staging deployment slot, deployed code to the staging deployment slot, and performed a slot swap.


## Exercise 2: Manage scalability and performance of Azure web apps

Estimated Time: 25 minutes

The main tasks for this exercise are as follows:

1. Configure and test autoscaling of the Azure web app

1. Configure Content Delivery Network (CDN) for the Azure web app


#### Task 1: Configure and test autoscaling of the Azure web app

1. In the Azure portal, from the web app blade, display the **Scale out (App Service plan)** blade. 

1. On the web app **Scale out (App Service plan)** blade, enable autoscale with the following settings:

    - Autoscale setting name: **az1010201-AutoScaling**

    - Resource group: **az1010201-RG**

    - **Default Auto created scale condition**: 

        - Scale mode: **Scale based on a metric**

        - Rules: **Scale out**

        - When: 

            - Time aggregation: **Average**

            - Metric name: **Data In**

            - Time grain statistics: **Average**

            - Operator: **Greater than**

            - Threshold: **1048576** bytes

            - Duration: **5** minutes

            - Cool down (minutes): **5**

        - Instance limits (Minimum): **1**

        - Instance limits (Maximum): **2**

        - Instance limits (Default): **1**

    - **Auto created scale condition 1**: 

        - Scale mode: **Scale based on a metric**

        - Rules: **Scale in**

        - When: 

            - Time aggregation: **Average**

            - Metric name: **Data In**

            - Time grain statistics: **Average**

            - Operator: **Greater than**

            - Threshold: **1048576** bytes

            - Duration: **5** minutes

            - Cool down (minutes): **5**

        - Instance limits (Minimum): **1**

        - Instance limits (Maximum): **1**

        - Instance limits (Default): **1**

        - Schedule: **Repeat specific days**

        - Repeat every: **Monday**, **Tuesday**, **Wednesday**, **Thursday**, **Friday**, **Saturday**, **Sunday**

        - Timezone: **(UTC-5:00) Eastern Time (US & Canada)**

        - Start time: **00:00**

        - End time: **23:59**

1. From the Azure Portal, start a PowerShell session in the Cloud Shell. 

1. In the Cloud Shell pane, run the following commands:

   ```
   $resourceGroup = Get-AzureRmResourceGroup -Name 'az1010201-RG'
   $webapp = Get-AzureRmWebApp -ResourceGroupName $resourceGroup.ResourceGroupName
   while ($true) { Invoke-WebRequest -Uri $webapp.DefaultHostName }
   ```

   > **Note**: These commands submit requests to the Azure web app in a loop in order to trigger autoscaling

1. Minimize the Cloud Shell pane and, from the web app blade, display the **Process explorer** blade. This will allow you to monitor the number of instances and their resource utilization. 

1. Once you notice that the number of instances has increased to 2, reopen the Cloud Shell pane and terminate the PowerShell script by pressing **Ctrl+C**.

   > **Note**: It might take about 5 minutes for the number of instances to increase to 2


#### Task 2: Configure Content Delivery Network (CDN) for the Azure web app

1. In the Azure portal, navigate to the **Create a resource** blade.

1. From the **Create a resource** blade, search Azure Marketplace for **CDN**.

1. Use the list of search results to navigate to the **CDN profiile** blade.

1. From the **CDN profile** blade, create a CDN profile with the following settings:

    - App name: **az1010202cdn-profile**

    - Subscription: the name of the Azure subscription you are using in this lab

    - Resource group: the name of a new resource group **az1010202-RG**

    - Location: the name of an Azure region where you can provision Azure CDN

    - Pricing tier: **Standard Microsoft**

    - Create a new CDN endpoint now: enabled

    - CDN endpoint name: any unique, valid name consisting of letters and digits

    - Origin type: **Web App**

    - Origin hostname: the fully qualified name of the web app you created in the first exercise

   > **Note**: The green check mark in the **CDN endpoint name** text box will indicate whether the name you typed in is valid and unique. 

   > **Note**: Wait until the CDN endpoint is created before you proceed to the next task. This should take less than a minute.

1. In the Azure portal, navigate to the **az1010202cdn-profile** blade.

1. From the **az1010202cdn-profile** blade, note the list of endpoints and use it to navigate to the newly created endpoint.

1. From the endpoint blade, note the value of the **Endpoint hostname**. 

1. Open a new tab of Microsoft Edge and browse to the URL representing the **Endpoint hostname**. Note that the browser displays the **Hello World!** page you just deployed.

> **Result**: After you completed this exercise, you have configured and tested autoscaling of the Azure web app as well as configured Content Delivery Network (CDN) for the Azure web app.
