<#
.SYNOPSIS
    This PowerShell script ensures that the number of allowed bad logon attempts is configured to three or less.

.NOTES
    Author          : Ellie Pham
    LinkedIn        : linkedin.com/in/elliephamtx/
    GitHub          : github.com/elliepham
    Date Created    : 2026-08-07
    Last Modified   : 2026-08-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000010
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-AC-000010/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AC-000010.ps1 
#>

#Requires -RunAsAdministrator

net accounts /lockoutthreshold:3

if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure Account Lockout Threshold."
}

Write-Host "Account lockout threshold set to 3 attempts."
