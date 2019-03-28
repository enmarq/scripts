#This script allows you to export O365 License assignment for user or shared mailboxes
# Please run the below script from O365 PowerShell

Get-MsolUser -All | Where {$_.IsLicensed -eq $true } | Select userprincipalname, displayname, country, state, department,@{n="LastDirSyncTime";e={$_.LastDirSyncTime}},@{n="Licenses Type";e={$_.Licenses.AccountSKUid}},SignInName,UserPrincipalName,City,@{n="ProxyAddresses";e={$_.ProxyAddresses}},@{n="PrimarySMTPAddress";e={$_.proxyAddresses | where {$_.startsWith("SMTP:")}}} | Export-csv -Path C:\temp\O365users.csv -notype