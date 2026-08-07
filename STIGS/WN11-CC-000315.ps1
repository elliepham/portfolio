<#
.SYNOPSIS
    This PowerShell script ensures that the Windows Installer feature "Always install with elevated privileges" is disabled to prevent standard users from gaining full system control.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-06
    Last Modified   : 2024-08-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000315
    Documentation   : https://stigaview.com/products/win11/v2r1/WN11-CC-000315/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000315.ps1 
#>

# Requires Administrator privileges

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$valueName = "AlwaysInstallElevated"
$valueData = 0

# Create the key if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty `
    -Path $registryPath `
    -Name $valueName `
    -Value $valueData `
    -PropertyType DWord `
    -Force | Out-Null

Write-Host "AlwaysInstallElevated has been set to 0."

# Requires Administrator privileges for HKLM

$settings = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer",
    "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"
)

foreach ($path in $settings) {
    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }

    New-ItemProperty `
        -Path $path `
        -Name "AlwaysInstallElevated" `
        -Value 0 `
        -PropertyType DWord `
        -Force | Out-Null
}

Write-Host "AlwaysInstallElevated has been disabled for both Computer and User policies."
