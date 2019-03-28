#Users in each licensing group - (run from O365 PowerShell)

$securityGroup = Get-MsolGroup -GroupType "Security" | Where-Object {$_.DisplayName -eq "Test Security Group"}

Get-MsolGroupMember -GroupObjectId $securityGroup.ObjectId | Export-csv "c:\GrpMem.csv"

