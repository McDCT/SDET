[DscLocalConfigurationManager()]
Configuration RegisterNode
{
    Settings {
            RefreshFrequencyMins           = 30;
            RefreshMode                    = 'PULL';
            ConfigurationMode              = 'ApplyAndAutoCorrect';
            AllowModuleOverwrite           = $true;
            RebootNodeIfNeeded             = $true;
            ConfigurationModeFrequencyMins = 60;
        }

        ConfigurationRepositoryWeb ConfigurationManager
        {
            ServerURL          = 'https://PullServer.StrongCobra.com/PSDSCPullServer.svc'
            RegistrationKey    = '140a952b-b9d6-406b-b416-e0f759c9c0e4'  
            ConfigurationNames = @('sc-dc1')
        }
    
}
#$cim_session = New-CimSession -ComputerName 'localhost' -Credential administrator
RegisterNode -OutputPath 'C:\Users\Public\dsc'
Start-Sleep 60
#Set-DscLocalConfigurationManager -CimSession $cim_session -Path 'C:\Users\Public\dsc'
Set-DscLocalConfigurationManager -Path 'C:\Users\Public\dsc'