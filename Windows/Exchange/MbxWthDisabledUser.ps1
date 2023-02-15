Write-Host "Disabled User Accounts with Exchange Mailboxes Report" -ForegroundColor Green
Write-Host "Created By: www.ThatLazyAdmin.com" -ForegroundColor Green
$data = Get-mailbox -ResultSize Unlimited |Where-Object {$_.ExchangeUserAccountControl -eq "AccountDisabled"} |select Name,ExchangeUserAccountControl,IsLinked,IsResource,ResourceType, RecipientType, PrimarySmtpAddress, Database, WhenMailboxCreated
$count = @($data).Count
$subject = "Mailbox with Disabled User Accounts Report"
$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
$data |ConvertTo-Html -Head $Header -Title $subject -PreContent "<h1> $subject :Total Mailboxes $count</h1>" -CssUri "MXReport.css" |Set-Content "MBXReport.html" | Out-File DisabledUserWithMbx.html
