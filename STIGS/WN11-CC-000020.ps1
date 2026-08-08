<#
.SYNOPSIS
    This PowerShell script ensures that IPv6 source routing is configured to highest protection.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000020
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-CC-000020/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000020.ps1 
#>

#Requires -RunAsAdministrator

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
$valueName    = "DisableIPSourceRouting"
$valueData    = 2

# Create the registry key if it does not already exist.
if (-not (Test-Path -LiteralPath $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Configure IPv6 source routing to the highest protection level.
New-ItemProperty `
    -LiteralPath $registryPath `
    -Name $valueName `
    -PropertyType DWord `
    -Value $valueData `
    -Force | Out-Null

# Verify the resulting configuration.
$result = Get-ItemPropertyValue `
    -LiteralPath $registryPath `
    -Name $valueName

if ($result -ne $valueData) {
    throw "Verification failed. DisableIPSourceRouting is set to $result instead of $valueData."
}

Write-Host "WN11-CC-000020 configured successfully."
Write-Host "IPv6 DisableIPSourceRouting = $result (Highest protection)"
