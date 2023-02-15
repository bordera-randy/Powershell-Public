Get-Recipient | Select Name -ExpandProperty EmailAddresses | Select Name, SmtpAddress | Export-csv c:\temp\AllEmailAddress.csv

Get-Mailbox -ResultSize Unlimited |Select-Object DisplayName,PrimarySmtpAddress, @{Name=”EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_.PrefixString -ceq “smtp”} | ForEach-Object {$_.SmtpAddress}}}

Get-distributiongroup -ResultSize Unlimited |Select-Object DisplayName,PrimarySmtpAddress, @{Name=”EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_.PrefixString -ceq “smtp”} | ForEach-Object {$_.SmtpAddress}}}