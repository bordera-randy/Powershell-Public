$age = read-host -Prompt 'Input the number of days for the last contact of the ActiveSync device:'
$mailfrom = read-host -Prompt 'Input the from email address:'
$mailto = read-host -Prompt 'Input the to email address:'
$mailserver = read-host -Prompt 'Input the SMTP server name or ip address:'
Get-EASDeviceReport.ps1 -age $age -sendemail -mailfrom $mailfrom -mailto $mailto -mailserver $mailserver