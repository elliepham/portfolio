<#
.SYNOPSIS
    This PowerShell script ensures that PowerShell script block logging is enabled on Windows 11.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-08
    Last Modified   : 2026-08-08
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000326
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-CC-000326/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000326.ps1 
#>


$Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
$Name = 'EnableScriptBlockLogging'

$Value = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue).$Name

if ($Value -ne 1) {
    Write-Output "Non-compliant: Enabling PowerShell Script Block Logging."

    New-Item -Path $Path -Force | Out-Null
    New-ItemProperty `
        -Path $Path `
        -Name $Name `
        -PropertyType DWord `
        -Value 1 `
        -Force | Out-Null
}

$Value = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop).$Name

if ($Value -eq 1) {
    Write-Output "Compliant: WN11-CC-000326."
    exit 0
}

Write-Output "Non-compliant: WN11-CC-000326."
exit 1
