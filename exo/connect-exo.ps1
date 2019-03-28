## O365 Connection Script: (Open PowerShell in Admin mode and run this script)

######## Connect to Office 365 ########
 Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\PowerShell -Name ExecutionPolicy -Value ByPass
ECHO "Attempting connection to Office 365"

# Importing MS Online Modules
Import-Module MsOnline
Import-Module MSOnlineExtended

#Connecting to MS Online  -- Remove-PSSession $Session
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic –AllowRedirection
Import-PSSession $Session -AllowClobber

Connect-MsolService -Credential $LiveCred
ECHO ""
ECHO ""
ECHO "Connection Successful"

#Fetch Orgname
$OrgName = Get-MsolCompanyInformation | select -exp DisplayName
$InitialDomain = Get-MsolCompanyInformation | select -exp InitialDomain
$host.ui.RawUI.WindowTitle = "You are connected to: " + $OrgName + " (" + $InitialDomain + ") "
ECHO ""
ECHO ""
$ECHO = "You are connected to: " + $OrgName + " (" + $InitialDomain + ") "
ECHO $ECHO
cd\
