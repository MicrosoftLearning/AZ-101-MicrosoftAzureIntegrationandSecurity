configuration InstallHyperV 
{ 

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
    {
        WindowsFeature HyperV 
        { 
            Ensure = "Present" 
            Name = "Hyper-V"
            IncludeAllSubFeatures = $true
        }

        WindowsFeature HyperV-PowerShell
        { 
            Ensure = "Present" 
            Name = "Hyper-V-PowerShell"
            IncludeAllSubFeatures = $true
        }

        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
   }
} 