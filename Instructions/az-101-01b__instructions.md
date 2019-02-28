# AZ 101 Module 1 - Migrate Servers
# Lab 2: Migrate on-premises Hyper-V VMs to Azure

Estimated Time: 120 minutes

All tasks in this lab are performed from the Azure portal (including a PowerShell Cloud Shell session)  

   > **Note**: When not using Cloud Shell, the lab virtual machine must have the Azure PowerShell 1.2.0 module (or newer) installed [https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0)

Lab files: 

-  **Allfiles/Labfiles/AZ-101.1/az-101-01b_azuredeploy.json**

-  **Allfiles/Labfiles/AZ-101.1/az-101-01b_azuredeploy.parameters.json**

-  **Allfiles/Labfiles/AZ-101.1/DSC/InstallHyperV.ps1**

-  **Allfiles/Labfiles/AZ-101.1/DSC/InstallHyperV.zip**


### Scenario
  
Adatum Corporation wants to implement Azure Site Recovery to facilitate migration and protection of on premises Hyper-V VMs


### Objectives
  
After completing this lab, you will be able to:

-  Implement Azure Site Recovery Vault

-  Configure replication of Hyper-V VMs to Azure by using Azure Site Recovery


## Exercise 1: Implement prerequisites for migration of Hyper-V VMs to Azure by using Azure Site Recovery
  
Estimated Time: 40 minutes

The main tasks for this exercise are as follows:

1. Provision an Azure VM with nested virtualization support by using an Azure Resource Manager template

1. Create an Azure Recovery Services vault
  

#### Task 1: Provision an Azure VM with nested virtualization support by using an Azure Resource Manager template

1. From the lab virtual machine, start Microsoft Edge, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using a Microsoft account that has the Owner role in the Azure subscription you intend to use in this lab.

1. From the Azure Portal, start a PowerShell session in the Cloud Shell. 

   > **Note**: If this is the first time you are launching the Cloud Shell in the current Azure subscription, you will be asked to create an Azure file share to persist Cloud Shell files. If so, accept the defaults, which will result in creation of a storage account in an automatically generated resource group.

1. In the Cloud Shell pane, upload **az-101-01b_azuredeploy.ps1**, **az-101-01b_azuredeploy.json**, **az-101-01b_azuredeploy.parameters.json**, **InstallHyperV.ps1**, and **InstallHyperV.zip** files.

1. In the Cloud Shell pane, run the following in order to copy the **InstallHyperV.ps1** and **InstallHyperV.zip** files to a DSC subfolder in the home directory.

   ```
   Set-Location -Path $HOME

   New-Item -Type Directory -Path '.\DSC'

   Move-Item -Path '.\InstallHyperV.*' -Destination '.\DSC'
   ```

1. In the Cloud Shell pane, run the following in order to deploy a Standard_DS2_v3 Azure VM (substitute the `<location>` placeholder with the name of the Azure region where you want to perform deployment):

   ```
   ./az-101-01b_azuredeploy.ps1 -resourceGroupName 'az1010101b-RG' -resourceGroupLocation <location>
   ```

   > **Note**: To identify Azure regions where you can provision Azure VMs, refer to [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

   > **Note**: If the deployment fails due to the Standard_DS2_v3 size not being available, identify another Azure VM size that supports nested virtualization and specify this size explicitly during the deployment by using the following syntax (substitute the `<vm_Size>` placeholder with the intended Azure VM size)

   ```
   .\az-101-01b_azuredeploy.ps1 -resourceGroupName 'az1010101b-RG' -resourceGroupLocation <location> -vmSize <vm_Size>
   ```

   > **Note**: Do not wait for the deployment to complete but proceed to the next task. You will use the virtual machine **az1010101b-vm1** in the next exercise of this lab.

#### Task 2: Implement an Azure Site Recovery vault
 
1. In the Azure portal, navigate to the **New** blade.

1. From the **New** blade, search Azure Marketplace for **Backup and Site Recovery (OMS)**.

1. Use the list of search results to navigate to the **Recovery Services vault** blade.

1. Use the **Recovery Services vault** blade, to create a Site Recovery vault with the following settings:

    - Name: **vaultaz1010102bb**

    - Subscription: the same Azure subscription you used in the previous task of this exercise

    - Resource group: the name of a new resource group **az1010102b-RG**

    - Location: the same Azure region that you selected in the previous task of this exercise.

> **Result**: After you completed this exercise, you have initiated deployment of an Azure VM with nested virtualization support by using an Azure Resource Manager template and created an Azure Recovery Services vault


## Exercise 2: Migrate a Hyper-V VM to Azure by using Azure Site Recovery

Estimated Time: 80 minutes
  
The main tasks for this exercise are as follows:

1. Provision a Hyper-V VM

1. Prepare infrastructure for Hyper-V VM replication

1. Configure Hyper-V VM replication

1. Review Hyper-V VM replication settings 


#### Task 1: Provision a Hyper-V VM

   > **Note**: Before you start this task, ensure that the template deployment you started in the first exercise has completed. 

1. In the Azure portal, navigate to the blade of the **az1010101b-vm1** Azure VM. 

1. From the **Overview** pane of the **az1000401-vm2** blade, generate an RDP file and use it to connect to **az1010101b-vm1**.

1. When prompted, authenticate by specifying the following credentials:

    - User name: **Student**

    - Password: **Pa55w.rd1234**

1. Within the RDP session to **az1010101b-vm1**, start Hyper-V Manager.

1. In the Hyper-V Manager console, use Virtual Switch Manager to create an internal switch named **Internal**. 

1. In the Hyper-V Manager console, use New Virtual Machine Wizard to create a Hyper-V VM with the following settings:

    - Name: **az1010101b-vm2**

    - Generation: **1**

    - Startup memory: **2048**

    - Connection: **Internal**

    - Create a virtual disk: 

        - Name: **az1010101b-vm2.vhdx**

        - Location: **C:\\Users\\Public\\Documents\\Hyper-V\\Virtual Hard Disks\\**

        - Size: **32 GB**

    - Installation Options: **Install an operating system later**

   > **Note**: You will not be installing operating system on the Hyper-V VM. Its sole purpose is to illustrate configuration of the Site Recovery replication.


#### Task 2: Prepare infrastructure for Hyper-V VM replication

1. Within the RDP session, in Server Manager, navigate to the Local Server view and turn off temporarily **IE Enhanced Security Configuration**.

1. Within the RDP session, start Internet Explorer, browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the same Microsoft account you used previously in this lab.

1. In the Azure portal, navigate to the **az1010102b-RG** resource group blade.

1. From the **az1010102b-RG** resource group blade, navigate to the **vaultaz1010102b** Recovery Services vault blade.

1. From the **vaultaz1010102b** blade, navigate to the **Site Recovery infrastructure** blade.

1. From the **Site Recovery infrastructure** blade, navigate to the **Site Recovery infrastructure - Hyper-V Sites** blade.

1. From the **Site Recovery infrastructure - Hyper-V Sites** blade, navigate to the **Create Hyper-V site** blade.

1. On the **Create Hyper-V site** blade, create a new site named **Adatum Hyper-V Site**.

1. From the **Site Recovery infrastructure** blade, navigate to the **Site Recovery infrastructure - Hyper-V Hosts** blade.

1. From the **Site Recovery infrastructure - Hyper-V Hosts** blade, navigate to the **Add Server** blade.

1. From the **Add Server** blade, use the **Download the installer for the Microsoft Azure Site Recovery Provider** link to download and initiate the installation of the Azure Site Recovery Provider.

1. Run Azure Site Recovery Provider Setup. On the initial page of the setup wizard, turn of the automatic check for updates.

1. After the installation completes, use the **Register** command button to continue to register the local Hyper-V host with the Azure Site Recovery vault by launching **Microsoft Azure Site Recovery Registration Wizard**.

1. Switch to the Azure portal and, from the **Add Server** blade, download the vault registration key for the **Adatum Hyper-V Site** to the **Downloads** folder on the local Hyper-V host.

1. Switch back to the **Microsoft Azure Site Recovery Registration Wizard** and, on the **Vault Settings** page, select the newly downloaded key file. 

1. Verify that the subscription, vault name, and Hyper-V site name are correct and complete the registration.

1. Switch back to the Azure portal, navigate to the **Site Recovery infrastructure - Hyper-V Hosts** blade, and verify that the **az1010102b-vm1** appears on the list of servers with the **Connected** status.

1. From the **Site Recovery infrastructure - Hyper-V Hosts** blade, navigate to the **vaultaz1010102b - Site Recovery** blade.

1. From the **vaultaz1010102b - Site Recovery** blade, navigate to the **Prepare Infrastructure** blade and specify the following settings:

    - Protection goal:

        - Where are your machines located?: **On-premises**

        - Where do you want to replicate your machines to?: **To Azure**

        - Are your machines virtualized?: **Yes, with Hyper-V**

        - Are you using System Center VMM to manage your Hyper-V hosts?: **No**

    - Deployment planning:

        - Have you completed deployment planning?: **Yes, I have done it**

    - Prepare source:

        - Step 1: Select Hyper-V Site: **Adatum Hyper-V Site**

        - Step 2: Ensure Hyper-V servers are added: **az1010102b-vm1**

    - Target: 

        - Step 1: Select Azure subscription: 

            - Subscription: the same subscription you selected earlier in this lab

            - Select the deployment model used after failover: **Resource Manager**

        - Step 2: Ensure that at least one compatible Azure storage account exists:

            - Use the **+ Storage account** option to create a **Storage (general purpose v1)** **Standard** storage account with **Locally-redundant storage (LRS)** replication settings.

      > **Note**: The new storage account will be automatically created in the same resource group as the Azure Site Recovery vault.

        - Step 3: Ensure that at least one compatible Azure virtual network exists: 

            - Use the **+ Network** option to create a virtual network named **az-1010102b-vnet2** with the address space of **10.201.16.0/20**, a subnet named **subnet0**, and the subnet range of **10.201.16.0/24**.

      > **Note**: The new virtual network will be automatically created in the same resource group as the Azure Site Recovery vault.

    - Replication policy:

        - Use the **+Create and Associate option** to navigate to the **Create and associate policy** and configure the policy with the following settings:

            - Name: **Adatum Hyper-V VM replication policy**

            - Source type: **Hyper-V**

            - Target type: **Azure**

            - Copy frequency: **5 Minutes**

            - Recovery point retention in hours: **2**

            - App-consistent snapshot frequency in hours: **1**

            - Initial replication start time: **Immediately**

            - Associated Hyper-V site: **Adatum Hyper-V Site**

   > **Note**: From the **Replication policy** blade, you can use the **View job in progress** links to navigate to the **Associate replication policy** blade and monitor progress of applying the replication policy.

1. Navigate back to the **Prepare infrastructure** blade and finalize the configuration. 


#### Task 3: Enable Hyper-V VM replication

1. Within the RDP session, in the Azure portal, navigate to the **vaultaz1010102b** blade.

1. From the **vaultaz1010102b** blade, navigate to the **vaultaz1010102b - Replicated items** blade.

1. From the **vaultaz1010102b - Replicated items** blade, navigate to the **Enable replication** blade and enable Hyper-V VM replication with the following settings:

    - Source:

        - Source: **On-premises**

        - Source location: **Adatum Hyper-V Site**

    - Target:

        - Target: **Azure**

        - Subscription: the same subscription you selected earlier in this lab

        - Post-failover resource group: **az1010102b-RG**

        - Post-failover deployment model: **Resource Manager**

        - Storage account: the storage account you created in the previous task

        - Azure network: **Configure now for selected virtual machines**

        - Post-failover virtual network: **az-1010102b-vnet2**

        - Subnet: **subnet0 (10.201.16.0/24)**

    - Select virtual machines: 

        - **az1010101b-vm2**

    - Configure properties: 

        - Defaults:

            - OS TYPE: **Windows**

            - OS DISK: **Need to select per VM.**

            - DISK TO REPLICATE: **Need to select per VM.**

        - az1010101b-vm2:

            - OS TYPE: **Windows**

            - OS DISK: **az1010101b-vm2**

            - DISK TO REPLICATE: **All Disks [1]**

    - Configure replication settings:

        - Replication policy: **Adatum Hyper-V VM replication policy**

1. Back on the **Enable replication blade**, enable replication.


#### Task 4: Review Hyper-V VM replication settings

1. Within the RDP session, in the Azure portal, on the **vaultaz1010102b - Replicated items** blade, ensure that there is an entry representing the **az1010101b-vm2** Azure VM and verify that its **REPLICATION HEALTH** is **Healthy**.

   > **Note**: You might need to refresh the view of the page in order to view the replicated VM. 

1. Monitor the **STATUS** column and wait until it changes to **Protected**. 

1. From the **vaultaz1010102b - Replicated items** blade, navigate to the replicated item blade of the **vaultaz1010102b** Hyper-V VM.

1. On the **az1010101b-vm** replicated item blade, review the **Health and status**, **Failover readiness**, **Latest recovery points**, and **Infrastructure view** sections. Note the **Planned Failover**, **Failover** and **Test Failover** toolbar icons.

> **Result**: After you completed this exercise, you have provisioned a Hyper-V VM, prepared infrastructure for Hyper-V VM replication, configure Hyper-V VM replication, and reviewed Hyper-V VM replication settings.