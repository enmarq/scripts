# Script created by Santhosh Kumar - For any queries please contact santhosh.kumar@enmarq.com - Happy Scripting! ## 

Get-CASMailbox -resultsize unlimited | Select Name,DisplayName,ActiveSyncEnabled,PrimarySmtpAddress | Export-Csv "C:\temp \ActiveSync.csv"