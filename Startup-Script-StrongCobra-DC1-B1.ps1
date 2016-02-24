#Requires -Version 5.0
#Requires -runasadministrator
# This Startup Script should be placed into the Project's script Bucket

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

$path_2_add = 'C:\Scripts\StrongCobra-Project\StrongCloud-Project-Menus'
# Modify machine system environment variable
[Environment]::SetEnvironmentVariable($path_2_add, $env:Path, [System.EnvironmentVariableTarget]::Machine)

# Create and then apply the configuration to register this node with the pullserver
RegisterNode -ComputerName 'strongcobra-dc1-b1' -OutputPath 'C:\Users\Public\dsc'
Set-DscLocalConfigurationManager -ComputerName localhost -Path 'C:\Users\Public\dsc'

# Placing this node's LCM AgentId into a txt file for quick reference
(Get-DscLocalConfigurationManager).AgentId | Out-File 'C:\Users\Public\dsc\DscLocalConfig.txt' -Force
#endregion