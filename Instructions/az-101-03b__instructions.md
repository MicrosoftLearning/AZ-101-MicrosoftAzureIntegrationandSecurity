# AZ 101 Module 3 - Implement Advanced Virtual Networking
# Lab 2: Use Azure Network Watcher for monitoring and troubleshooting network connectivity

Estimated Time: 90 minutes

All tasks in this lab are performed from the Azure portal (including a PowerShell Cloud Shell session)  

   > **Note**: When not using Cloud Shell, the lab virtual machine must have the Azure PowerShell 1.2.0 module (or newer) installed [https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0)

Lab files: 

-  **Allfiles/Labfiles/AZ-101.3/az-101-03b_01_azuredeploy.json**

-  **Allfiles/Labfiles/AZ-101.3/az-101-03b_02_azuredeploy.json**

-  **Allfiles/Labfiles/AZ-101.3/az-101-03b_01_azuredeploy.parameters.json**

-  **Allfiles/Labfiles/AZ-101.3/az-101-03b_02_azuredeploy.parameters.json**


### Scenario
  
Adatum Corporation wants to monitor Azure virtual network connectivity by using Azure Network Watcher.


### Objectives
  
After completing this lab, you will be able to:

-  Deploy Azure VMs, Azure storage accounts, and Azure SQL Database instances by using Azure Resource Manager templates

-  Use Azure Network Watcher to monitor network connectivity


## Exercise 1: Prepare infrastructure for Azure Network Watcher-based monitoring
  
Estimated Time: 45 minutes

The main tasks for this exercise are as follows:

1. Deploy Azure VMs, an Azure Storage account, and an Azure SQL Database instance by using an Azure Resource Manager template

1. Enable Azure Network Watcher service

1. Establish peering between Azure virtual networks

1. Establish service endpoints to an Azure Storage account and Azure SQL Database instance


#### Task 1: Deploy Azure VMs, an Azure Storage account, and an Azure SQL Database instance by using Azure Resource Manager templates

1. From the lab virtual machine, start Microsoft Edge, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using a Microsoft account that has the Owner role in the target Azure subscription.

1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Template deployment**.

1. Use the list of search results to navigate to the **Custom deployment** blade.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, load the template file **az-101-03b_01_azuredeploy.json**. 

   > **Note**: Review the content of the template and note that it defines deployment of an Azure VM, an Azure SQL Database, and an Azure Storage account.

1. Save the template and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, navigate to the **Edit parameters** blade.

1. From the **Edit parameters** blade, load the parameters file **az-101-03b_01_azuredeploy.parameters.json**. 

1. Save the parameters and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, initiate a template deployment with the following settings:

    - Subscription: the name of the subscription you intend to use in this lab

    - Resource group: the name of a new resource group **az1010301b-RG**

    - Location: the name of the Azure region which is closest to the lab location and where you can provision Azure VMs

    - Vm Size: **Standard_DS1_v2**

    - Vm Name: **az1010301b-vm1**

    - Admin Username: **Student**

    - Admin Password: **Pa55w.rd1234**

    - Virtual Network Name: **az1010301b-vnet1**

    - Sql Login Name: **Student**

    - Sql Login Password: **Pa55w.rd1234**

    - Database Name: **az1010301b-db1**

    - Sku Name: **Basic**

    - Sku Tier: **Basic**

   > **Note**: To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

   > **Note**: Do not wait for the deployment to complete but proceed to the next step. 

1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Template deployment**.

1. Use the list of search results to navigate to the **Custom deployment** blade.

1. On the **Custom deployment** blade, select the **Build your own template in the editor**.

1. From the **Edit template** blade, load the template file **az-101-03b_02_azuredeploy.json**. 

   > **Note**: Review the content of the template and note that it defines deployment of an Azure VM.

1. Save the template and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, navigate to the **Edit parameters** blade.

1. From the **Edit parameters** blade, load the parameters file **az-101-03b_02_azuredeploy.parameters.json**. 

1. Save the parameters and return to the **Custom deployment** blade. 

1. From the **Custom deployment** blade, initiate a template deployment with the following settings:

    - Subscription: the name of the subscription you are using in this lab

    - Resource group: the name of a new resource group **az1010302b-RG**

    - Location: the name of an Azure region where you can provision Azure VMs, but which is different from the one you selected during previous deployment, 

    - Vm Size: **Standard_DS1_v2**

    - Vm Name: **az1010302b-vm2**

    - Admin Username: **Student**

    - Admin Password: **Pa55w.rd1234**

    - Virtual Network Name: **az1010302b-vnet2**

   > **Note**: Make sure to choose a different Azure region for this deployment

   > **Note**: Do not wait for the deployment to complete but proceed to the next step. 


#### Task 2: Enable Azure Network Watcher service

1. In the Azure portal, use the search text box on the **All services** blade to navigate to the **Network Watcher** blade.

2. On the **Network Watcher** blade, verify that Network Watcher is enabled in both Azure regions into which you deployed resources in the previous task and, if not, enable it.


#### Task 3: Establish peering between Azure virtual networks

   > **Note**: Before you start this task, ensure that the template deployment you started in the first task of this exercise has completed. 

1. In the Azure portal, navigate to the **az1010301b-vnet1** virtual network blade.

1. From the **az1010301b-vnet1** virtual network blade, display the **az1010301b-vnet1 - Peerings** blade.

1. From the **az1010301b-vnet1 - Peerings** blade, create a VNet peering with the following settings:

    - Name: **az1010301b-vnet1-to-az1010302b-vnet2**

    - Virtual network deployment model: **Resource manager**

    - Subscription: the name of the Azure subscription you are using in this lab

    - Virtual network: **az1010302b-vnet2**

    - Allow virtual network access: **Enabled**

    - Allow forwarded traffic: disabled

    - Allow gateway transit: disabled

    - Use remote gateways: disabled

1. In the Azure portal, navigate to the **az1010302b-vnet2** virtual network blade.

1. From the **az1010302b-vnet2** virtual network blade, display the **az1010302b-vnet2 - Peerings** blade.

1. From the **az1010302b-vnet2 - Peerings** blade, create a VNet peering with the following settings:

    - Name: **az1010302b-vnet2-to-az1010301b-vnet1**

    - Virtual network deployment model: **Resource manager**

    - Subscription: the name of the Azure subscription you are using in this lab

    - Virtual network: **az1010301b-vnet1**

    - Allow virtual network access: **Enabled**

    - Allow forwarded traffic: disabled

    - Allow gateway transit: disabled

    - Use remote gateways: disabled


#### Task 4: Establish service endpoints to an Azure Storage account and Azure SQL Database instance

1. In the Azure portal, navigate to the **az1010301b-vnet1** virtual network blade.

1. From the **az1010301b-vnet1** virtual network blade, display the **az1010301b-vnet1 - Service endpoints** blade.

1. From the **az1010301b-vnet1 - Service endpoints** blade, add service endpoints with the following settings:

    - Service: **Microsoft.Storage**

    - Subnets: **subnet0**

    - Service: **Microsoft.Sql**

    - Subnets: **subnet0**

1. In the Azure portal, navigate to the **az1000301b-RG** resource group blade.

1. From the **az1010301b-RG** resource group blade, navigate to the blade of the storage account included in the resource group. 

1. From the storage account blade, navigate to its **Firewalls and virtual networks** blade.

1. From the **Firewalls and virtual networks** blade of the storage account, configure the following settings:

    - Allow access from: **Selected networks**

    - Virtual networks: 

        - VIRTUAL NETWORK: **az1010301b-vnet1**

            - SUBNET: **subnet0**

    - Firewall: 

        - ADDRESS RANGE: none

    - Exceptions: 

        - Allow trusted Microsoft services to access this storage account: **Enabled**

        - Allow read access to storage logging from any network: **Disabled**

        - Allow read access to storage metrics from any network: **Disabled**

1. In the Azure portal, navigate to the **az1010301b-RG** resource group blade.

1. From the **az1010301b-RG** resource group blade, navigate to the **az1010301b-db1** Azure SQL Database blade. 

1. From the **az1010301b-db1** Azure SQL Database blade, navigate to its server's **Firewall settings** blade.

1. From the **Firewall settings** blade of the Azure SQL Database server, configure the following settings:

    - Allow access to Azure services: **ON**

    - No firewall rules configured 

    - Virtual networks:

        - Name: **az1010301b-vnet1**

        - Subscription: the name of the subscription you are using in this lab

        - Virtual network: **az1010301b-vnet1**

        - Subnet name: **subnet0/ 10.203.0.0/24**

> **Result**: After you completed this exercise, you have deployed Azure VMs, an Azure Storage account, and an Azure SQL Database instance by using Azure Resource Manager templates, enabled Azure Network Watcher service, established global peering between Azure virtual networks, and established service endpoints to an Azure Storage account and Azure SQL Database instance.


## Exercise 2: Use Azure Network Watcher to monitor network connectivity
  
Estimated Time: 45 minutes

The main tasks for this exercise are as follows:

1. Test network connectivity to an Azure VM via virtual network peering by using Network Watcher

1. Test network connectivity to an Azure Storage account by using Network Watcher

1. Test network connectivity to an Azure SQL Database by using Network Watcher


#### Task 1: Test network connectivity to an Azure VM via virtual network peering by using Network Watcher

1. In the Azure portal, navigate to the **Network Watcher** blade.

1. From the **Network Watcher** blade, navigate to the **Network Watcher - Connection troubleshoot**.

1. On the **Network Watcher - Connection troubleshoot** blade, initiate a check with the following settings:

    - Source: 

        - Subscription: the name of the Azure subscription you are using in this lab

        - Resource group: **az1010301b-RG**

        - Source type: **Virtual machine**

        - Virtual machine: **az1010301b-vm1**

    - Destination: **Specify manually**

        - URI, FQDN or IPv4: **10.203.16.4**

      > **Note**: **10.203.16.4** is the private IP address of the second Azure VM az1010301b-vm1 which you deployed to another Azure region

    - Probe Settings:

        - Protocol: **TCP**

        - Destination port: **3389**

    - Advanced settings:

        - Source port: blank

1. Wait until results of the connectivity check are returned and verify that the status is **Reachable**. Review the network path and note that the connection was direct, with no intermediate hops in between the VMs.

    > **Note**: If this is the first time you are using Network Watcher, the check can take up to 5 minutes.


#### Task 2: Test network connectivity to an Azure Storage account by using Network Watcher

1. From the Azure Portal, start a PowerShell session in the Cloud Shell. 

   > **Note**: If this is the first time you are launching the Cloud Shell in the current Azure subscription, you will be asked to create an Azure file share to persist Cloud Shell files. If so, accept the defaults, which will result in creation of a storage account in an automatically generated resource group.

1. In the Cloud Shell pane, run the following command to identify the IP address of the blob service endpoint of the Azure Storage account you provisioned in the previous exercise:

   ```
   [System.Net.Dns]::GetHostAddresses($(Get-AzStorageAccount -ResourceGroupName 'az1010301b-RG')[0].StorageAccountName + '.blob.core.windows.net').IPAddressToString
   ```

1. Note the resulting string and, from the **Network Watcher - Connection troubleshoot** blade, initiate a check with the following settings:

    - Source: 

        - Subscription: the name of the Azure subscription you are using in this lab

        - Resource group: **az1010301b-RG**

        - Source type: **Virtual machine**

        - Virtual machine: **az1010301b-vm1**

    - Destination: **Specify manually**

        - URI, FQDN or IPv4: the IP address of the blob service endpoint of the storage account you identified in the previous step of this task

    - Probe Settings:

        - Protocol: **TCP**

        - Destination port: **443**

    - Advanced settings:

        - Source port: blank

1. Wait until results of the connectivity check are returned and verify that the status is **Reachable**. Review the network path and note that the connection was direct, with no intermediate hops in between the VMs, with minimal latency. 

    > **Note**: The connection takes place over the service endpoint you created in the previous exercise. To verify this, you will use the **Next hop** tool of Network Watcher.

1. From the **Network Watcher - Connection troubleshoot** blade, navigate to the **Network Watcher - Next hop** blade and test next hop with the following settings:

    - Subscription: the name of the Azure subscription you are using in this lab

    - Resource group: **az1010301b-RG**

    - Virtual machine: **az1010301b-vm1**

    - Network interface: **az1010301b-nic1**

    - Source IP address: **10.203.0.4**

    - Destination IP address: the IP address of the blob service endpoint of the storage account you identified earlier in this task

1. Verify that the result identifies the next hop type as **VirtualNetworkServiceEndpoint**

1. From the **Network Watcher - Connection troubleshoot** blade, initiate a check with the following settings:

    - Source: 

        - Subscription: the name of the Azure subscription you are using in this lab

        - Resource group: **az1010302b-RG**

        - Source type: **Virtual machine**

        - Virtual machine: **az1010302b-vm2**

    - Destination: **Specify manually**

        - URI, FQDN or IPv4: the IP address of the blob service endpoint of the storage account you identified earlier in this task

    - Probe Settings:

        - Protocol: **TCP**

        - Destination port: **443**

    - Advanced settings:

        - Source port: blank

1. Wait until results of the connectivity check are returned and verify that the status is **Reachable**. 

    > **Note**: The connection is successful, however it is established over Internet. To verify this, you will use again the **Next hop** tool of Network Watcher.

1. From the **Network Watcher - Connection troubleshoot** blade, navigate to the **Network Watcher - Next hop** blade and test next hop with the following settings:

    - Subscription: the name of the Azure subscription you are using in this lab

    - Resource group: **az1010302b-RG**

    - Virtual machine: **az1010302b-vm2**

    - Network interface: **az1010302b-nic1**

    - Source IP address: **10.203.16.4**

    - Destination IP address: the IP address of the blob service endpoint of the storage account you identified earlier in this task

1. Verify that the result identifies the next hop type as **Internet**


#### Task 3: Test network connectivity to an Azure SQL Database by using Network Watcher

1. From the Azure Portal, start a PowerShell session in the Cloud Shell. 

1. In the Cloud Shell pane, run the following command to identify the IP address of the Azure SQL Database server you provisioned in the previous exercise:

   ```
   [System.Net.Dns]::GetHostAddresses($(Get-AzSqlServer -ResourceGroupName 'az1010301b-RG')[0].FullyQualifiedDomainName).IPAddressToString
   ```

1. Note the resulting string and, from the **Network Watcher - Connection troubleshoot** blade, initiate a check with the following settings:

    - Source: 

        - Subscription: the name of the Azure subscription you are using in this lab

        - Resource group: **az1010301b-RG**

        - Source type: **Virtual machine**

        - Virtual machine: **az1010301b-vm1**

    - Destination: **Specify manually**

        - URI, FQDN or IPv4: the IP address of the Azure SQL Database server you identified in the previous step of this task

    - Probe Settings:

        - Protocol: **TCP**

        - Destination port: **1433**

    - Advanced settings:

        - Source port: blank

1. Wait until results of the connectivity check are returned and verify that the status is **Reachable**. Review the network path and note that the connection was direct, with no intermediate hops in between the VMs, with low latency. 

    > **Note**: The connection takes place over the service endpoint you created in the previous exercise. To verify this, you will use the **Next hop** tool of Network Watcher.

1. From the **Network Watcher - Connection troubleshoot** blade, navigate to the **Network Watcher - Next hop** blade and test next hop with the following settings:

    - Subscription: the name of the Azure subscription you are using in this lab

    - Resource group: **az1010301b-RG**

    - Virtual machine: **az1010301b-vm1**

    - Network interface: **az1010301b-nic1**

    - Source IP address: **10.203.0.4**

    - Destination IP address: the IP address of the Azure SQL Database server you identified earlier in this task

1. Verify that the result identifies the next hop type as **VirtualNetworkServiceEndpoint**

1. From the **Network Watcher - Connection troubleshoot** blade, initiate a check with the following settings:

    - Source: 

        - Subscription: the name of the Azure subscription you are using in this lab

        - Resource group: **az1010302b-RG**

        - Source type: **Virtual machine**

        - Virtual machine: **az1010302b-vm2**

    - Destination: **Specify manually**

        - URI, FQDN or IPv4: the IP address of the Azure SQL Database server you identified earlier in this task

    - Probe Settings:

        - Protocol: **TCP**

        - Destination port: **1433**

    - Advanced settings:

        - Source port: blank

1. Wait until results of the connectivity check are returned and verify that the status is **Reachable**. 

    > **Note**: The connection is successful, however it is established over Internet. To verify this, you will use again the **Next hop** tool of Network Watcher.

1. From the **Network Watcher - Connection troubleshoot** blade, navigate to the **Network Watcher - Next hop** blade and test next hop with the following settings:

    - Subscription: the name of the Azure subscription you are using in this lab

    - Resource group: **az1010302b-RG**

    - Virtual machine: **az1010302b-vm2**

    - Network interface: **az1010302b-nic1**

    - Source IP address: **10.203.16.4**

    - Destination IP address: the IP address of the Azure SQL Database server you identified earlier in this task

1. Verify that the result identifies the next hop type as **Internet**


> **Result**: After you completed this exercise, you have used Azure Network Watcher to test network connectivity to an Azure VM via virtual network peering, network connectivity to Azure Storage, and network connectivity to Azure SQL Database.
