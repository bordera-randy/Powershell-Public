# Please Configure the following variables....
$smtpServer= "192.168.10.15"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$expireindays = 10
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
    
  if ($daystoexpire -lt $expireindays)
  {
	$msg = new-object Net.Mail.MailMessage
	$msg.subject="Your password will expire in $daystoexpire days"
	$msg.From = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
	$msg.ReplyTo = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
	$path = "C:\Scripts\Images"
	$files= Get-ChildItem $path
	Foreach($file in $files)
		{	 
			$attachment = New-Object System.Net.Mail.Attachment –ArgumentList $Path\$file
			$attachment.ContentDisposition.Inline = $True
			$attachment.ContentDisposition.DispositionType = "Inline"
			$attachment.ContentType.MediaType = "image/jpg"
			$attachment.ContentId = $file
			$msg.Attachments.Add($attachment)
		}
    $msg.To.Add($emailaddress)
    $msg.IsBodyHtml = $True
	$msg.body = get-content -Path .\PasswordChangeInstructions.htm
	$smtp.Send($msg)
	$attachment.dispose();
	$msg.dispose();
  }  
}