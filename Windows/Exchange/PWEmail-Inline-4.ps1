Import-Module ActiveDirectory
$Dates = get-date -format o
$charPos = $Dates.IndexOf("T")
$Dates = $Dates.Substring(0,$charPos)
$ScriptLogLocation = ("C:\Scripts\Logs\" + $Dates + "-ScriptLog" + ".txt")
$CurrentScriptLogLocation = "C:\Scripts\Logs\Current-ScriptLog.txt"
Start-Transcript -path $ScriptLogLocation
clear-host

# Please Configure the following variables....
$smtpServer= "192.168.10.15"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$expireindays = 10
#uncomment this line and comment line 46 for testing
#$emailaddress = "dbrown@ironedgegroup.com"

#Get Users From AD who are enabled
$users = get-aduser -Server TRI-COLO-DC03 -filter * -properties * |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false } | where { $_.passwordexpired -eq $false } | where { $_.emailaddress -ne $null }
#$Dates = get-date -format M #commented out 10/3 b/c $Dates was already set in line 3
$PWLogLocation = ("C:\Scripts\Logs\" + $Dates + "-PWLog" + ".txt")

#Build email with from, inline images, and body
$msg = new-object Net.Mail.MailMessage
$msg.From = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
$msg.ReplyTo = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
$imgpath = "C:\Scripts\Images"
$files= Get-ChildItem $imgpath
Foreach($file in $files)
    {
        $attachment = New-Object System.Net.Mail.Attachment –ArgumentList $imgpath\$file
        $attachment.ContentDisposition.Inline = $True
        $attachment.ContentDisposition.DispositionType = "Inline"
        $attachment.ContentType.MediaType = "image/jpg"
        $attachment.ContentId = $file
        $msg.Attachments.Add($attachment)
    }
$msg.IsBodyHtml = $True
$HTMLpath = "C:\Scripts"
$msg.body = get-content -Path $HTMLPath\PasswordChangeInstructions.htm

	
#add subject and recipient, send email, then clear subject and recipient in prep for next user
foreach ($user in $users)
{
    $Name = (Get-ADUser $user | foreach { $_.Name})
    $emailaddress = $user.emailaddress
    #echo "$Name HAS an email address"
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
	#echo "$Name : DaystoExpire is $daystoexpire, ExpiresInDays is $expireindays"
    if ($daystoexpire -lt $expireindays)
    {
	    $msg.subject="$Name, your password will expire in $daystoexpire days."
	    $msg.To.Add($emailaddress)
	    $smtp.Send($msg)
        $msg.To.Remove($emailaddress)
        $msg.Subject.Clear
        #echo "The user $name will be sent an email for password expiry"
        write-output "$Name will be sent an email for password expiry, $daystoexpire days till expiration" | Out-File -FilePath $PWLogLocation -Append
    }
}

#cleanup email before ending
$attachment.dispose();
$msg.dispose();
Stop-Transcript
#Remove-Item $CurrentScriptLogLocation
New-Item -ItemType File -Path $CurrentScriptLogLocation -Force
Copy-Item -Path $ScriptLogLocation -Destination $CurrentScriptLogLocation -Force