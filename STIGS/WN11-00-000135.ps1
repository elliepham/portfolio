<#
.SYNOPSIS
    This PowerShell script ensures that a host-based firewall is installed and enabled on the system.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000135
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-00-000135/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-00-000135.ps1 
#>

#Requires -RunAsAdministrator

# WN11-00-000135
# Ensure Windows Defender Firewall is installed and enabled.

$firewallService = Get-Service -Name 'mpssvc' -ErrorAction Stop

# Ensure the Windows Defender Firewall service starts automatically.
if ($firewallService.StartType -ne 'Automatic') {
    Set-Service -Name 'mpssvc' -StartupType Automatic
}

# Start the firewall service if it is not running.
if ($firewallService.Status -ne 'Running') {
    Start-Service -Name 'mpssvc'
}

# Enable Windows Defender Firewall for all profiles.
Set-NetFirewallProfile `
    -Profile Domain,Private,Public `
    -Enabled True

# Verify the configuration.
$service = Get-Service -Name 'mpssvc'
$profiles = Get-NetFirewallProfile -Profile Domain,Private,Public

$serviceOK = (
    $service.Status -eq 'Running' -and
    $service.StartType -eq 'Automatic'
)

$firewallOK = ($profiles | Where-Object { $_.Enabled -ne $true }).Count -eq 0

if (-not $serviceOK) {
    throw "Verification failed: Windows Defender Firewall service is not running or is not configured for automatic startup."
}

if (-not $firewallOK) {
    throw "Verification failed: Windows Defender Firewall is not enabled for all profiles."
}

Write-Host "WN11-00-000135 configured successfully."
Write-Host "Windows Defender Firewall service: $($service.Status)"
Write-Host "Firewall enabled: Domain, Private, Public"
