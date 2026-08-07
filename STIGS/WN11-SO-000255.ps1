<#
.SYNOPSIS
    This PowerShell script ensures that User Account Control must automatically deny elevation requests for standard users.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000255
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-SO-000255/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-SO-000255.ps1 
#>

#Requires -RunAsAdministrator
#
# Applies the specified registry settings from:
# HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
#

$systemPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$auditPath        = Join-Path $systemPolicyPath "Audit"
$uipiPath         = Join-Path $systemPolicyPath "UIPI"
$clipboardPath    = Join-Path $uipiPath "Clipboard"
$exceptionPath    = Join-Path $clipboardPath "ExceptionFormats"

# Create registry keys if they do not already exist
@(
    $systemPolicyPath
    $auditPath
    $uipiPath
    $clipboardPath
    $exceptionPath
) | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -Path $_ -Force | Out-Null
    }
}

# REG_DWORD values under Policies\System
$dwordValues = @{
    ConsentPromptBehaviorAdmin         = 5
    ConsentPromptBehaviorEnhancedAdmin = 1
    ConsentPromptBehaviorUser          = 0
    DSCAutomationHostEnabled           = 2
    EnableCursorSuppression            = 1
    EnableFullTrustStartupTasks        = 2
    EnableInstallerDetection           = 1
    EnableLUA                          = 1
    EnableSecureUIAPaths               = 1
    EnableUIADesktopToggle             = 0
    EnableUwpStartupTasks              = 2
    EnableVirtualization               = 1
    PromptOnSecureDesktop              = 1
    SupportFullTrustStartupTasks       = 1
    SupportUwpStartupTasks             = 1
    TypeOfAdminApprovalMode            = 1
    ValidateAdminCodeSignatures        = 0
    dontdisplaylastusername            = 0
    scforceoption                      = 0
    shutdownwithoutlogon               = 1
    undockwithoutlogon                 = 1
}

foreach ($entry in $dwordValues.GetEnumerator()) {
    New-ItemProperty `
        -Path $systemPolicyPath `
        -Name $entry.Key `
        -PropertyType DWord `
        -Value $entry.Value `
        -Force | Out-Null
}

# REG_SZ values under Policies\System
$stringValues = @{
    legalnoticecaption = ""
    legalnoticetext    = ""
}

foreach ($entry in $stringValues.GetEnumerator()) {
    New-ItemProperty `
        -Path $systemPolicyPath `
        -Name $entry.Key `
        -PropertyType String `
        -Value $entry.Value `
        -Force | Out-Null
}

# Clipboard exception formats (REG_DWORD)
$clipboardFormats = @{
    CF_BITMAP      = 0x02
    CF_DIB         = 0x08
    CF_DIBV5       = 0x11
    CF_OEMTEXT     = 0x07
    CF_PALETTE     = 0x09
    CF_TEXT        = 0x01
    CF_UNICODETEXT = 0x0D
}

foreach ($entry in $clipboardFormats.GetEnumerator()) {
    New-ItemProperty `
        -Path $exceptionPath `
        -Name $entry.Key `
        -PropertyType DWord `
        -Value $entry.Value `
        -Force | Out-Null
}

Write-Host "Successfully applied registry settings."
Write-Host "Some settings may require a restart or sign out/sign in to take effect."

