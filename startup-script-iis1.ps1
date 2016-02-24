#Requires -Version 2.0
#Requires -runasadministrator
# This Startup Script should be placed into the Project's script Bucket

#region Alter the UAC of the machine
function Set-UACStatus {
  <#
  .SYNOPSIS
    Enables or disables User Account Control (UAC) on a computer.

  .DESCRIPTION
    Enables or disables User Account Control (UAC) on a computer.

  .NOTES
    Version      		: 1.0
    Rights Required : Local admin on server
                    : ExecutionPolicy of RemoteSigned or Unrestricted
    Credits(s)      : Pat Richard (pat@innervation.com); MATI(StrongCobra@google.com)

  .EXAMPLE
    Set-UACStatus -Enabled [$true|$false]

    Description
    -----------
    Enables or disables UAC for the local computer. Set as last command in a startup script then
    set -Restart to have the machine restart after.

  .EXAMPLE
    Set-UACStatus -Computer [computer name] -Enabled [$true|$false]

    Description
    -----------
    Enables or disables UAC for the computer specified via -Computer.
  #>

  param(
    [cmdletbinding()]
    [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
    [string]$Computer = $env:ComputerName,
    [parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
    [bool]$enabled,
    [switch]$Restart
  )
  [string]$RegistryValue = 'EnableLUA'
  [string]$RegistryPath = 'Software\Microsoft\Windows\CurrentVersion\Policies\System'
  $OpenRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
  $Subkey = $OpenRegistry.OpenSubKey($RegistryPath,$true)
  $Subkey.ToString() | Out-Null
  if ($enabled -eq $true){
    $Subkey.SetValue($RegistryValue, 1)
  }else{
    $Subkey.SetValue($RegistryValue, 0)
  }
  $UACStatus = $Subkey.GetValue($RegistryValue)
  #$UACStatus

  # As a startup place as last command and set restart as true
  if ($Restart){
    Restart-Computer $Computer -force
    Write-Host "Rebooting $Computer"
  }else{
    Write-Host "Restarting $Computer is now required."
  }
} # end function Set-UACStatus
#endregion

#region BEGIN DSC REGISTER WITH PULLSERVER
[DscLocalConfigurationManager()]
Configuration RegisterNode
{
<#
  .SYNOPSIS
  Register this machine with a known pullserver.

  .DESCRIPTION
  Registers the LCM AgentId with the environment pullserver to enable DSC configuration.

  .NOTES
  Version         : 1.0
  Rights Required : Local admin on server
                  : ExecutionPolicy of RemoteSigned or Unrestricted
                  : Meant for use in a startup script
  Credits(s)      : MATI(StrongCobra@google.com)

  .EXAMPLE
  RegisterScDc1 -ComputerName 'duhComputer' -OutputPath 'C:\Users\Public\dsc'

  Description
  -----------
  Runs the DSC configuration and places duhComputer.MOF into a known good and always available path.
#>
  param (
    [string[]] $ComputerName = $env:ComputerName
  )
  Settings
  {
    RefreshFrequencyMins = 30;
    RefreshMode = 'PULL';
    ConfigurationMode = 'ApplyOnly';
    AllowModuleOverwrite  = $true;
    RebootNodeIfNeeded = $true;
    ConfigurationModeFrequencyMins = 60;
  }

  ConfigurationRepositoryWeb ConfigurationManager
  {
    ServerURL = 'https://PullServer.StrongCobra.com/PSDSCPullServer.svc'
    RegistrationKey = '140a952b-b9d6-406b-b416-e0f759c9c0e4'  
    ConfigurationNames = @($ComputerName)
  }       
}

#endregion


#region BEGIN SCRIPT
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -RemoteAddress '10.240.0.0/16'
Set-Item wsman:\localhost\Client\TrustedHosts -value 'Strong-Cobra-01' -Force
# Permanently adding path to the path env var
$path_2_add = 'C:\Scripts\StrongCobra-Project\StrongCloud-Project-Menus'
# Modify machine system environment variable
[Environment]::SetEnvironmentVariable($path_2_add, $env:Path, [System.EnvironmentVariableTarget]::Machine)

# Create and then apply the configuration to register this node with the pullserver
RegisterNode -ComputerName 'sc-iis1' -OutputPath 'C:\Users\Public\dsc'
Set-DscLocalConfigurationManager -ComputerName localhost -Path 'C:\Users\Public\dsc'

# Placing this node's LCM AgentId into a txt file for quick reference
(Get-DscLocalConfigurationManager).AgentId | Out-File 'C:\Users\Public\dsc\DscLocalConfig.txt' -Force

# The following will reboot the machine
Set-UACStatus -Computer localhost -enabled $true -Restart
#endregion