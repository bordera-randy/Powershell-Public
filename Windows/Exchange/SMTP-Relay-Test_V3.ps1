 
<#     

.NOTES 
#=============================================
# Script      : SMTP-Relay-Test_V3.ps1 
# Created     : ISE 3.0  
# Author(s)   : casey.dedeal  
# Date        : 04/17/2018 13:49:52  
# Org         : ETC Solutions 
# File Name   : SMTP-Relay Test
# Comments    :
# Assumptions : 
#==============================================

SYNOPSIS           : SMTP-Relay-Test_V3.ps1 
DESCRIPTION        : Test SMTP Relay 
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\SMTP-Relay-Test_V3.ps1 

  Description
  -----------
  you will need to set few variables, to make sure this script runs within your environment

  #(4)_.Change these Variables to make it fit into your environment
  $smtpServer1 = "10.100.99.99"
  $smtpFrom    = "Relay_Test@ETCsol.com"  $smtpTo      = "Aki.Armstrong@ETCsol.com"


  Script MAP:

 #(1)_.Adding information and Vars
 #(2)_.Starting loop 
 #(3)_.Variables
 #(4)_.Change these Variables to make it fit into your environment
 #(5)_.Message additional vars
 #(6)_.Subject body vars
 #(7)_.Information map
 #(8)_.Sending To Relay Server 
 #(9)_.Completed



#> 
#(1)_.Adding information and Varsclear-hostwrite-host $nullWrite-Host "(1_).Starting Bulk SMTP Relay Test" -f w -b Greenwrite-host $null#(2)_.Starting loop foreach($RelayTest in 1..10){
    
#(3)_.Variables

$now         = Get-Date
$var1        = "Test conducted from Server --->[$Computer]"
$var2        = "Sent @ $now" 
$subject     = "Testing SMTP Relay ( $var1 ) "
$body        = "Smtp Relay TEST ---> "
$now         = Get-Date

#(4)_.Change these Variables to make it fit into your environment
$smtpServer1 = "10.100.99.99"
$smtpFrom    = "Relay_Test@ETCsol.com"$smtpTo      = "Aki.Armstrong@ETCsol.com"
#(5)_.Message additional vars
$Computer = $env:computername
$message  = " sent from "

#(6)_.Subject body vars
$messageSubject = $subject + $var2 
$messageBody = $body + $message +$Computer+$var2
#(7)_.Information map
write-host $null
Write-host "--------------------------" -ForegroundColor Yellow
Write-host "(-)_.Sending SMTP relay e-mail" -ForegroundColor White
Write-host "(-)_.SMTP gateway" -f Green -NoNewline; write-host " [ $smtpServer1 ] " -f Cyan
Write-host "(-)_.Recepients  " -f Green -NoNewline; write-host " [ $smtpTo ] " -f Cyan
Write-host "--------------------------" -ForegroundColor Yellow
#(8)_.Sending To Relay Server 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer1)
$smtp.Send($smtpFrom,$smtpTo,$messagesubject,$messagebody)
Write-Host "(-)_.Message Sent." -ForegroundColor Green


}

#(9)_.Completed
Write-Host "(-)_.Bulk relay test completed." -f w -b Green