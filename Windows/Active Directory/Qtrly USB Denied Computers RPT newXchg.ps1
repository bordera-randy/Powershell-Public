#Get USB Allowed Computers and email to BoSA-IT 
# Please Configure the following variables....
$smtpServer= 'mail.thebankofsa.com'
$from = "Randy Bordeaux <rbordeaux@managediron.com>"
Import-Module ActiveDirectory
$usbdeniedrpt = Get-ADComputer -Filter * -SearchBase "OU= No USB Storage,OU=SBSComputers,OU=Computers,OU=BOSA,DC=BOFSA,DC=LOCAL" | format-table  -wrap -autosize -property name | out-file c:\scripts\reports\USBDenied.txt
$LogLocation = ("C:\Scripts\reports\" + "USB Denied" + ".txt")
$emailaddress = "DSOreports@thebankofsa.com"
$subject="Quarterly USB Denied Report"
$body = "
<html>
	<body>
		<p>Charles,<`/p>
		<p><strong>This is the Quarterly USB Denied Computers report.<`/strong><`/p>
		<p>If you have any questions about this report please contact Randy Bordeaux at rbordeaux@ironedgegroup.com 
    "
Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High -Attachments "c:\scripts\reports\USBDenied.txt"
out-file -filepath $LogLocation

