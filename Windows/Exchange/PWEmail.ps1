# Please Configure the following variables....
$smtpServer= "192.168.10.15"
$expireindays = 10
$from = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
###################################################################################################################

#Get Users From AD who are enabled
Import-Module ActiveDirectory
$users = get-aduser -filter * -properties * |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false } | where { $_.passwordexpired -eq $false }
$Dates = get-date -format M
$LogLocation = ("C:\Scripts\" + "PWLog" + $Dates + ".txt")
foreach ($user in $users)
{ 
  $Name = (Get-ADUser $user | foreach { $_.Name})
  $emailaddress = $user.emailaddress
  $passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })
  $PasswordPol = (Get-AduserResultantPasswordPolicy $user)
    # Check for Fine Grained Password
  if (($PasswordPol) -ne $null)
  {
    $maxPasswordAge = ($PasswordPol).MaxPasswordAge
  }
  
  else
  {
    $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
  }
  
  
  $expireson = $passwordsetdate + $maxPasswordAge
  $today = (get-date)
  $daystoexpire = (New-TimeSpan -Start $today -End $Expireson).Days
  $subject="Your password will expire in $daystoExpire days"
  $body = "
<html>
	<body>
		<p>Dear $name,<`/p>
		<p><strong><span style=`"color:red`">This is an official message from the Tricon IT Staff.<`/span><`/strong><`/p>
		<p>Your Password for email and any network access you currently have will expire in <span style=`"color:red`">$daystoexpire<`/span> days.<`/p>
		<p>To change your password, follow these steps:<`/p>
			<p style=`"margin-left:.5in;text-indent:-.25in`"><span style=`"font-family: Symbol;`">&middot;<`/span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Logon to Webmail <a href=`"https://mail.triconenergy.com/owa/`">Microsoft Outlook Web Access<`/a><`/p>
			<p style=`"margin-left:.5in;text-indent:-.25in`"><span style=`"font-family: Symbol;`">&middot;<`/span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Choose Options &gt; Change Password<`/p>
			<p>If you need assistance, please create a ManagedIron Help Desk ticket. You can use either method below:<`/p>
			<p style=`"margin-left:.5in;text-indent:-.25in`"><span style=`"font-family: Symbol;`">&middot;<`/span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Double click on the ManagedIron Help Desk Icon located in the system tray on your computer and filling in the ticket information<`/p>
            <p style=`"margin-left:.5in;text-indent:-.25in`"><span style=`"font-family: Symbol;`">&middot;<`/span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Submit an email from your official Tricon email account to <a href=`"mailto:HelpDesk@ManagedIron.com`">HelpDesk@ManagedIron.com<`/a><`/p>
	<`/body>
<`/html>"
  
  if ($daystoexpire -lt $expireindays)
  {
    Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High
    out-file -filepath $LogLocation
  }  
   
}