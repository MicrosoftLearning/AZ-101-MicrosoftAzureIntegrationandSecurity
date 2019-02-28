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

        WindowsFeature HyperV-Manager
        { 
            Ensure = "Present" 
            Name = "Microsoft-Hyper-V-Tools-All"
            IncludeAllSubFeature = $true
        }

        LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
   }
} 
