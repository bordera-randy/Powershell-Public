add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

Get-CASMailbox -ResultSize Unlimited | where { $_.ActiveSyncEnabled -eq 'True'} | ft name, activesyncenabled -autosize > c:\temp\ActiveSyncEnabled.txt
Get-CASMailbox -ResultSize Unlimited | where { $_.OWAEnabled -eq 'True'} | ft name, owaenabled -autosize > c:\temp\OWAEnabled.txt

Close-FileHandles c:\temp\ActiveSyncEnabled.txt
Close-FileHandles c:\temp\OWAEnabled.txt

start-sleep -s 20

$EmailFrom = "<exchange@thebankofsa.com>"
#$EmailTo = "<charles.gruber@thebankofsa.com>"
$EmailTo = "<sa.managediron@thebankofsa.com>"
$EmailSubject = "OWA/ActiveSync Enabled Users"
$SMTPServer = "10.221.72.72"
$OWAEmailAttachment = "c:\temp\OWAEnabled.txt"
$ASEmailAttachment = "c:\temp\ActiveSyncEnabled.txt"
$EmailBody = "Monthly report for OWA & ActiveSync enabled users"
#function send_email {
    $mailmessage = New-Object system.net.mail.mailmessage 
    $mailmessage.from = ($EmailFrom)
    $mailmessage.To.add($EmailTo)
    $mailmessage.Subject = $EmailSubject
    $mailmessage.Body = $EmailBody
    $OWAattachment = New-Object System.Net.Mail.Attachment($OWAEmailAttachment, 'text/plain')
    $mailmessage.Attachments.Add($OWAattachment)
    $ASattachment = New-Object System.Net.Mail.Attachment($ASEmailAttachment, 'text/plain')
    $mailmessage.Attachments.Add($ASattachment)
    #$mailmessage.IsBodyHTML = $true
    $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, 25)  
    #$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("$SMTPAuthUsername", "$SMTPAuthPassword") 
    $SMTPClient.Send($mailmessage)
#}

function Close-FileHandles 
{ 
    param( 
     [parameter(mandatory=$True, HelpMessage='Full or partial file path')] 
     [string]$FilePath 
    ) 
    
    Write-Host "Searching for locks on path: $FilePath"

    gps | Where-Object { $_.Path -match $FilePath.Replace("\", "\\") } |% ` 
    { 
        Write-Host "Closing process $_.Name with path: $_.Path" 
        Stop-Process -Id $_.Id -Force 
    } 
}