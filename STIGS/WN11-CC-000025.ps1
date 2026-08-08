<#
.SYNOPSIS
    This PowerShell script ensures that the system is configured to prevent IP source routing.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000025 
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-CC-000025/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000025.ps1 
#>

#Requires -RunAsAdministrator

$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
$valueName    = 'DisableIPSourceRouting'
$valueData    = 2

# Create the registry key if it does not already exist.
if (-not (Test-Path -LiteralPath $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Configure IPv4 IP source routing:
# 0 = Enable source routing
# 1 = Source routing disabled for non-default routes
# 2 = Highest protection; source routing completely disabled
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

Write-Host 'WN11-CC-000025 configured successfully.'
Write-Host "IPv4 DisableIPSourceRouting = $actualValue (Highest protection)"
