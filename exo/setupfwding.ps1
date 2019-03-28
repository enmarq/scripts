#PowerShell Script to Forward setup
# Script created by Santhosh Kumar - For any queries please contact santhosh.kumar@enmarq.com - Happy Scripting! ## 

Get-Mailbox "<mailbox >" | select UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward | Export-csv D:\Office365Forwards.csv -NoTypeInformation

# $false: forward emails without storing
# $true: forwards email with storing

Set-Mailbox "<Mailbox to be forwarded>" -ForwardingSmtpAddress "< forwarded to>" -DeliverToMailboxAndForward $false

