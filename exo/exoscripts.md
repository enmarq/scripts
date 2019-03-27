**Powershell Scripts for Exchange Online**

1.  **Get All mailbox details:**

Get-Mailbox -ResultSize unlimited \| Select
Name,DisplayName,Alias,UserPrincipalName,WindowsEmailAddress,PrimarySmtpAddress,RecipientTypeDetails,RecipientType,Office,SKUAssigned,PSComputerName,ServerName,Database,
ForwardingSmtpAddress \| Export-Csv C:\\temp\\onpremusers.csv

2.  **Get Lastlogontime :**

Get-mailbox -resultsize unlimited \| Get-MailboxStatistics \| select
DisplayName,lastlogontime \| Export-Csv c:\\temp\\On-PremLastLogon.Csv

3.  **Script to Get Active Sync Users:**

Get-CASMailbox -resultsize unlimited \| Select
Name,DisplayName,ActiveSyncEnabled,PrimarySmtpAddress \| Export-Csv
\"C:\\temp \\ActiveSync.csv\"

4.  **Script to Get Mobile Device statistics:**

Get-Mailbox -ResultSize Unlimited \| ForEach {Get-MobileDeviceStatistics
-Mailbox:\$\_.Identity} \| Select-Object @{label="User" ;
expression={\$\_.Identity}},FirstSyncTime,LastSuccessSync,DeviceType,DeviceModel,DeviceOS,DeviceUserAgent,Status,DeviceAccessState,DeviceImei
\| Export-csv c:\\temp\\DeviceDetails.csv

**If Get-MobileDeviceStatistics does not work, please use
Get-ActiveSyncDeviceStatistics**

Get-Mailbox -ResultSize Unlimited \| ForEach
{Get-ActiveSyncDeviceStatistics -Mailbox:\$\_.Identity} \| Select-Object
@{label="User" ;
expression={\$\_.Identity}},FirstSyncTime,LastSuccessSync,DeviceType,DeviceModel,DeviceOS,DeviceUserAgent,Status,DeviceAccessState,DeviceImei
\| Export-csv c:\\temp\\DeviceDetails.csv

5.  **Powershell Script to Export sAMAccountName, and OU from AD**

Import-module ActiveDirectory

get-ADUser -Filter \* -Properties DisplayName \| Select-Object
DisplayName,sAMAccountName,Enabled,@{n=\'OU\';e={\$\_.canonicalname
-replace \"/\$(\$\_.cn)\",\"\"}} \| Export-Csv
\"C:\\temp\\ADUserSam\_OU\_Details.csv\" -Encoding \"Unicode\"

> **OR**

get-ADUser -Filter \* -Properties DisplayName \| Select-Object
DisplayName,sAMAccountName,Enabled,@{n=\'OU\';e={\$\_.canonicalname
-replace \"/\$(\$\_.cn)\",\"\"}} \| Export-Csv
\"C:\\temp\\ADUserSam\_OU\_Details.csv\"

6.  **Powershell Script to Export O365 license assignment for
    user/shared mailboxes (run from O365 PowerShell)**

Get-MsolUser -All \| Where {\$\_.IsLicensed -eq \$true } \| Select
userprincipalname, displayname, country, state,
department,@{n=\"LastDirSyncTime\";e={\$\_.LastDirSyncTime}},@{n=\"Licenses
Type\";e={\$\_.Licenses.AccountSKUid}},SignInName,UserPrincipalName,City,@{n=\"ProxyAddresses\";e={\$\_.ProxyAddresses}},@{n=\"PrimarySMTPAddress\";e={\$\_.proxyAddresses
\| where {\$\_.startsWith(\"SMTP:\")}}} \| Export-csv -Path
C:\\temp\\O365users.csv -notype

7.  **PowerShell Script to Forward setup**

Get-Mailbox \"\<mailbox \>\" \| select
UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward \|
Export-csv D:\\Office365Forwards.csv -NoTypeInformation

Set-Mailbox \"\<Mailbox to be forwarded\>\" -ForwardingSmtpAddress \"\<
forwarded to\>\" -DeliverToMailboxAndForward \$false

\$false: forwards email without storing

\$true : forwards email with storing

8.  **Users in each licensing group - (run from O365 PowerShell)**

\$securityGroup = Get-MsolGroup -GroupType "Security" \| Where-Object
{\$\_.DisplayName -eq "Test Security Group"}

Get-MsolGroupMember -GroupObjectId \$securityGroup.ObjectId \|
Export-csv "c:\\GrpMem.csv"

9.  **O365 Connection Script (To run all Msol scripts)**

+-----------------------------------------------------------------------+
| O365 Connection Script: (Open PowerShell in Admin mode and run this   |
| script)                                                               |
|                                                                       |
| \#\#\#\#\#\#\#\# Connect to Office 365 \#\#\#\#\#\#\#\#               |
|                                                                       |
| Set-ItemProperty -Path                                                |
| HKLM:\\Software\\Policies\\Microsoft\\Windows\\PowerShell -Name       |
| ExecutionPolicy -Value ByPass                                         |
|                                                                       |
| ECHO \"Attempting connection to Office 365\"                          |
|                                                                       |
| \# Importing MS Online Modules                                        |
|                                                                       |
| Import-Module MsOnline                                                |
|                                                                       |
| Import-Module MSOnlineExtended                                        |
|                                                                       |
| \#Connecting to MS Online \-- Remove-PSSession \$Session              |
|                                                                       |
| \$LiveCred = Get-Credential                                           |
|                                                                       |
| \$Session = New-PSSession -ConfigurationName Microsoft.Exchange       |
| -ConnectionUri https://ps.outlook.com/powershell/ -Credential         |
| \$LiveCred -Authentication Basic --AllowRedirection                   |
|                                                                       |
| Import-PSSession \$Session -AllowClobber                              |
|                                                                       |
| Connect-MsolService -Credential \$LiveCred                            |
|                                                                       |
| ECHO \"\"                                                             |
|                                                                       |
| ECHO \"\"                                                             |
|                                                                       |
| ECHO \"Connection Successful\"                                        |
|                                                                       |
| \#Fetch Orgname                                                       |
|                                                                       |
| \$OrgName = Get-MsolCompanyInformation \| select -exp DisplayName     |
|                                                                       |
| \$InitialDomain = Get-MsolCompanyInformation \| select -exp           |
| InitialDomain                                                         |
|                                                                       |
| \$host.ui.RawUI.WindowTitle = \"You are connected to: \" + \$OrgName  |
| + \" (\" + \$InitialDomain + \") \"                                   |
|                                                                       |
| ECHO \"\"                                                             |
|                                                                       |
| ECHO \"\"                                                             |
|                                                                       |
| \$ECHO = \"You are connected to: \" + \$OrgName + \" (\" +            |
| \$InitialDomain + \") \"                                              |
|                                                                       |
| ECHO \$ECHO                                                           |
|                                                                       |
| cd\\                                                                  |
+-----------------------------------------------------------------------+

10. **Delegation List: (Added as .ps1 file)**

+-----------------------------------------------------------------------+
| \$OutFile = "C:\\temp\\ALL\_Access\_Permissions.txt"                  |
|                                                                       |
| "DisplayName" + "\^" + "Email Address" + "\^" + "Full Access" + "\^"  |
| + "Send As" + "\^" + "Send On Behalf Of" \| Out-File \$OutFile -Force |
|                                                                       |
| \$Mailboxes = Get-Mailbox -resultsize unlimited \| Select Identity,   |
| Alias, DisplayName, DistinguishedName, WindowsEmailAddress            |
|                                                                       |
| ForEach (\$Mailbox in \$Mailboxes) {                                  |
|                                                                       |
| \#\$SendOnBehalfOf = Get-mailbox \$Mailbox.identity \| select Alias,  |
| @{Name='GrantSendOnBehalfTo';Expression={\[string\]::join(";",        |
| (\$\_.GrantSendOnBehalfTo))}}                                         |
|                                                                       |
| \$SendOnBehalfOf = Get-mailbox \$Mailbox.identity \| %                |
| {\$\_.GrantSendOnBehalfTo}                                            |
|                                                                       |
| \$SendAs = Get-ADPermission \$Mailbox.identity \| where               |
| {(\$\_.ExtendedRights -like "\*Send-As\*") -and -not (\$\_.User -like |
| "NT AUTHORITY\\SELF") -and -not (\$\_.User -like "s-1-5-21\*")} \| %  |
| {\$\_.User}                                                           |
|                                                                       |
| \#\$FullAccess = Get-MailboxPermission \$Mailbox.Identity \| ?        |
| {\$\_.AccessRights -eq "FullAccess" -and !\$\_.IsInherited} \| %      |
| {\$\_.User}                                                           |
|                                                                       |
| \$FullAccess = Get-MailboxPermission \$Mailbox.Identity \|            |
| ?{(\$\_.IsInherited -eq \$False) -and -not (\$\_.User -match "NT      |
| AUTHORITY")} \|Select                                                 |
| User,Identity,@{Name="AccessRights";Expression={\$\_.AccessRights}}   |
| \| % {\$\_.User}                                                      |
|                                                                       |
| \$Mailbox.DisplayName + "\^" + \$Mailbox.WindowsEmailAddress + "\^" + |
| \$FullAccess + "\^" + \$SendAs + "\^" + \$SendOnBehalfOf \| Out-File  |
| \$OutFile -Append }                                                   |
+-----------------------------------------------------------------------+

11. **Get Mailbox Size: ( added as .ps1 file)**

+-----------------------------------------------------------------------+
| \$DataPath = \"C:\\\<Path\>\\mailboxsize.csv\"                        |
|                                                                       |
| \$Results = @()                                                       |
|                                                                       |
| \$MailboxUsers = get-mailbox -resultsize unlimited                    |
|                                                                       |
| foreach(\$user in \$mailboxusers)                                     |
|                                                                       |
| {                                                                     |
|                                                                       |
| \$UPN = \$user.userprincipalname                                      |
|                                                                       |
| \$MbxStats = Get-MailboxStatistics \$UPN                              |
|                                                                       |
| \$Properties = @{                                                     |
|                                                                       |
| Name = \$user.DisplayName                                             |
|                                                                       |
| Alias = \$user.alias                                                  |
|                                                                       |
| TotItemSize = \$MbxStats.totalitemsize                                |
|                                                                       |
| }                                                                     |
|                                                                       |
| \$Results                                                             |
|                                                                       |
| = New-Object psobject -Property \$properties                          |
|                                                                       |
| }                                                                     |
|                                                                       |
| \$Results \| Select-Object Name,TotItemSize \| Export-Csv             |
| -notypeinformation -Path \$DataPath                                   |
+-----------------------------------------------------------------------+
