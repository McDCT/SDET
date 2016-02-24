#Requires -Version 4.0
#Requires -runasadministrator
#region BEGIN SCRIPT
Set-Executionpolicy -Scope currentuser -ExecutionPolicy UnRestricted -Force
Start-Sleep 5
Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -RemoteAddress '10.240.0.0/16'
Start-Sleep 5
Set-Item wsman:\localhost\Client\TrustedHosts -value 'Strong-Cobra-01' -Force
Start-Sleep 5

# This registers the computername with the pullserver
#RegisterNode -ComputerName 'strongcobra-dc1' -OutputPath 'C:\Users\Public\dsc'

#Set-DscLocalConfigurationManager -ComputerName localhost -Path 'C:\Users\Public\dsc'
#(Get-DscLocalConfigurationManager).AgentId | Out-File 'C:\Users\Public\dsc\DscLocalConfig.txt' -Force

# The following will reboot the machine
#Set-UACStatus -Computer localhost -enabled $true -Restart
#endregion