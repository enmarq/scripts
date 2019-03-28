#Powershell script to export samAccountName and OU from Active Directory

#import the Active Directory Modules
import-module ActiveDirectory

get-ADUser -Filter * -Properties DisplayName | Select-Object DisplayName,sAMAccountName,Enabled,@{n='OU';e={$_.canonicalname -replace "/$($_.cn)",""}} | Export-Csv "C:\temp\ADUserSam_OU_Details.csv" -Encoding "Unicode"

# If the above script does not work please run the below script 
get-ADUser -Filter * -Properties DisplayName | Select-Object DisplayName,sAMAccountName,Enabled,@{n='OU';e={$_.canonicalname -replace "/$($_.cn)",""}} | Export-Csv "C:\temp\ADUserSam_OU_Details.csv"
