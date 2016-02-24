#Requires -Version 2.0
#Requires -runasadministrator
# This Startup Script should be placed into the Project's script Bucket
#region FUNCTIONS
<#
.SYNOPSIS
 Add host to TrustedHost.
.DESCRIPTION
 Add a string representation of a host by name or IP"0.0.0.0" to
 WinRM TrustedHosts collection.
.PARAMETER $trustedhost
 This string is what you wish to add to the collection.
.PARAMETER $computername
 This is the computer target Default:localhost.
.EXAMPLE
 Add-TrustedHost "HOST1"
.INPUTS
 This script, as written, operates on a single host defaulting to the localhost.
.OUTPUTS
 Write-Host output of progress or failure.
#>

#function Add-TrustedHost {
#  [CmdletBinding()]
#  param (
#    [string]$TrustedHost,
#    [string]$ComputerName = $env:COMPUTERNAME
#  )
#
#  Write-Host 'Begin Function: ' (Get-ChildItem $MyInvocation.PSCommandPath | Select-Object -Expand Name)
#
#  if (Test-Connection -ComputerName $ComputerName -Quiet -Count 1) {
#
#    $cur_value = (get-item wsman:\localhost\Client\TrustedHosts).value
#
#    if ($cur_value -notmatch $TrustedHost) {
#      Write-Host '...collection before adding...'
#      Write-Host $cur_value
#      if(!($cur_value -match $TrustedHost)) {
#        set-item wsman:\localhost\Client\TrustedHosts -value $TrustedHost  -Concatenate -Force
#        $cur_value_after = (get-item wsman:\localhost\Client\TrustedHosts).value
#      }
#      Write-Host '...collection after adding...'
#      Write-Host $cur_value_after
#      return 0
#    }
#    else {
#      return 1
#    }
#  }
#  else {
#    Write-Warning -Message '$ComputerName is unreachable'
#    return -1
#  }
#}
#<#
#.SYNOPSIS
# Test DSC
#.DESCRIPTION
# Test DSC startup by creating a folder
##>
#Configuration DSCTestFileCreation
#{
#  param ($GUID)
#  Node $GUID
#  {
#    #Create a file
#    File MyFileExample
#    {
#      Ensure          = 'Present'
#      Type            = 'Directory'
#      DestinationPath = 'C:\users\public\dsc\Popcicle' 
#    }
#  }
#}
#
#$GUID = [system.guid]::NewGuid().tostring()
#$cfg = $GUID.Split('-')[0] + '-DSCTest-' + $GUID.Split('-')[4]
#
#DSCTestFileCreation -GUID $GUID -OutputPath 'C:\Users\Public\dsc'
#endregion

New-Item -Path 'C:\users\public\documents' -ItemType file -Name Test.txt
#region BEGIN SCRIPT
#Add-TrustedHost 'pullserver2'
#endregion