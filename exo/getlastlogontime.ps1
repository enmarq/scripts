Get-mailbox -resultsize unlimited | Get-MailboxStatistics | select DisplayName,lastlogontime | Export-Csv c:\temp\On-PremLastLogon.Csv