#Requires -Version 2.0
#Requires -runasadministrator
# This Startup Script should be placed into the Project's script Bucket
#region BEGIN SCRIPT
Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -RemoteAddress '10.240.0.0/16'
Start-Sleep 5
Set-Item wsman:\localhost\Client\TrustedHosts -value 'Strong-Cobra-01' -Force
Start-Sleep 5
# Permanently adding path to the path env var
$path_1_add = 'C:\Scripts\StrongCobra-Project'
$path_2_add = 'C:\Scripts\StrongCobra-Project\StrongCloud-Project-Menus'
[Environment]::SetEnvironmentVariable($path_1_add, $env:Path, [System.EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable($path_2_add, $env:Path, [System.EnvironmentVariableTarget]::Machine)
Start-Sleep 5
#endregion