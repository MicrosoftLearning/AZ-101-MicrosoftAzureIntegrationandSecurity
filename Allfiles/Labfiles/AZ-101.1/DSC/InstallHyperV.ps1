configuration InstallHyperV 
{ 

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
    {
        WindowsFeature HyperV 
        { 
            Ensure = "Present" 
            Name = "Hyper-V"
            IncludeAllSubFeature = $true
        }

        WindowsFeature HyperV-PowerShell
        { 
            Ensure = "Present" 
            Name = "Hyper-V-PowerShell"
            IncludeAllSubFeature = $true
        }

        WindowsFeature HyperV-Tools
        { 
            Ensure = "Present" 
            Name = "Hyper-V-Tools"
        }

        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
   }
} 
