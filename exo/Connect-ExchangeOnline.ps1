<#PSScriptInfo

.DESCRIPTION 
Connect or Disconnect to Exchange Online

.SYNOPSIS
This script will connect to Office 365's Exchange Online PowerShell.

.SYNTAX
Connect-ExchangeOnline [[-AdminUsername] <String>] [[-AdminPassword] <String>] [-Disconnect]

.EXAMPLE
Connect-ExchangeOnline
This example will prompt for the admin username and password

.EXAMPLE
Connect-ExchangeOnline AdminUser@GitBit.org AdminPassword123
This example will use the username and password you specify and skip prompting for credentials.

.EXAMPLE
Connect-ExchangeOnline -Disconnect
This example will disconnect the session from Exchange Online

.VERSION 1.0

.AUTHOR John Gruber (https://medium.com/@gruberjl)

.COMPANYNAME GitBit (https://medium.com/gitbit)

#>




Param(
    [Parameter(Position=1)]
    [string]$AdminUsername,

    [Parameter(Position=2)]
    [string]$AdminPassword,

    [switch]$Disconnect
)

if ($Disconnect) {
    Write-Host "Disonnecting from Exchange Online..." -ForegroundColor Cyan
    Get-PSSession | ?{$_.ConfigurationName -eq "Microsoft.Exchange" -and $_.State -eq "Opened"} | Remove-PSSession
} else {
    if ($AdminUsername -and $AdminPassword) {
        $encryptedPassword = ConvertTo-SecureString -AsPlainText -Force -String $AdminPassword
        $Cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $AdminUsername, $encryptedPassword
    } else {
        $Cred = Get-Credential
    }

    Write-Host "Connecting to Exchange Online..." -ForegroundColor Cyan
    $exchOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Cred -Authentication Basic -AllowRedirection -WarningAction SilentlyContinue -InformationAction SilentlyContinue
    Import-PSSession $exchOnlineSession -AllowClobber -DisableNameChecking -WarningAction SilentlyContinue -InformationAction SilentlyContinue
}