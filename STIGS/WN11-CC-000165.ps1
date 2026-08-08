<#
.SYNOPSIS
    This PowerShell script ensures that unauthenticated RPC clients are restricted from connecting to the RPC server.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000165
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-CC-000165/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000165.ps1 
#>

#Requires -RunAsAdministrator

# WN11-CC-000165
# Restrict unauthenticated RPC clients from connecting to the RPC server.

$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc'
$valueName    = 'RestrictRemoteClients'
$valueData    = 1

# Create the RPC policy key if it does not already exist.
if (-not (Test-Path -LiteralPath $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Configure RPC to restrict unauthenticated clients.
New-ItemProperty `
    -LiteralPath $registryPath `
    -Name $valueName `
    -PropertyType DWord `
    -Value $valueData `
    -Force | Out-Null

# Verify the configuration.
$actualValue = Get-ItemPropertyValue `
    -LiteralPath $registryPath `
    -Name $valueName

if ($actualValue -ne $valueData) {
    throw "Verification failed. $valueName is configured as $actualValue instead of $valueData."
}

Write-Host 'WN11-CC-000165 configured successfully.'
Write-Host "RestrictRemoteClients = $actualValue"
