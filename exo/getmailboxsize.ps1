#script to get the mailbox sizes
# Script created by Santhosh Kumar - For any queries please contact santhosh.kumar@enmarq.com - Happy Scripting! ## 

$DataPath = "C:\<Path>\mailboxsize.csv"
$Results = @()
$MailboxUsers = get-mailbox -resultsize unlimited
foreach($user in $mailboxusers)
{
$UPN = $user.userprincipalname
$MbxStats = Get-MailboxStatistics $UPN
$Properties = @{
Name = $user.DisplayName
Alias = $user.alias
TotItemSize = $MbxStats.totalitemsize
}
$Results 
= New-Object psobject -Property $properties
}
$Results | Select-Object Name,TotItemSize | Export-Csv -notypeinformation -Path $DataPath
