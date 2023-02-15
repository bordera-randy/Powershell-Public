# Created by:       Artur Jakonis 
# Creation date:    2016-09-27 
# Purpose: Collect older than 30 days log files, zip them and move to backup location 
 
Set-ExecutionPolicy RemoteSigned 
 
# set variables 
$Now = Get-Date 
$Days = "30" 
$TargetFolder = "C:\inetpub\logs\LogFiles\W3SVC1" #logs folder on the server 
$Extension = "*.log" #change extension to txt or other 
$LastWrite = $Now.AddDays(-$Days) 
$BackupLocation = "\\share_address\ServerName\W3SVC1" #change this line to your backup destination 
 
# create new directory for file movement 
$NewFolder=New-Item -ItemType Directory -Path "$TargetFolder\.\$((Get-Date).ToString('yyyy-MM-dd'))" 
 
# get files older than $Days and move them to previously created folder 
Get-Childitem $TargetFolder -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"} | move-item -destination "$NewFolder" 
 
# 7zip part. Install 7zip on the server in order to make this part workable 
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"}  
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"   
 
$Target = "$BackupLocation\$($NewFolder.name).zip" 
 
# 7ziparchive command 
sz a -mx=9 $Target $NewFolder 
 
#check if zip has been placed on the share and delete logs folder 
# 
#$CheckAndDelete= If (Test-Path $Target){ 
#    Remove-Item $NewFolder -recurse -force -confirm:$false 
# } 
# 
#
# Generate email with results in HTML and CSV attachment 
#$CSS = "BODY{font-family:Arial, Helvetica, sans-serif; font-size: 8pt;}" 
#$info | Out-File "\\share_address\ServerName\W3SVC1\CSV\LogsInfo.txt" 
#$inf = Get-Content "\\share_address\ServerName\W3SVC1\CSV\LogsInfo.txt" 
#$in= $inf | ConvertTo-Html -head $CSS 
# 
# email details 
#$SMTPServer="10.10.10.1" #change this to fit your needs 
#$recipients="admins@company.com" 
#$messagesubject="SERVERNAME logs handling | $Now" 
# 
#$Attachments="\\share_address\ServerName\W3SVC1\CSV\LogsInfo.txt" 
#send-mailmessage -from "no-reply@company.com" -to $recipients -subject $messagesubject -BodyAsHtml "$inf" -attachments $Attachments -smtpserver $SMTPServer -Verbose 
# 
# end