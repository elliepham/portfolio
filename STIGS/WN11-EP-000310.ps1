<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11 Kernel (Direct Memory Access) DMA Protection is enabled.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-EP-000310
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-EP-000310/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-EP-000310.ps1 
#>

#Requires -RunAsAdministrator
#
# Applies:
# HKLM\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection
#   DeviceEnumerationPolicy (REG_DWORD) = 0
#

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"

# Create the registry key if it does not exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty `
    -Path $registryPath `
    -Name "DeviceEnumerationPolicy" `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

Write-Host "Successfully configured Kernel DMA Protection policy."
