$Dates = get-date -format o
$charPos = $Dates.IndexOf("T")
$Dates = $Dates.Substring(0,$charPos)
$ScriptLogLocation = ("C:\Scripts\Logs\" + $Dates + "-ScriptLog" + ".txt")
Start-Transcript -path $ScriptLogLocation
#clear-host

#Set all error as terminating errors so that exceptions can be caught
$ErrorActionPreference = 'Stop'

#Set variables for use
$CurrentScriptLogLocation = "C:\Scripts\Logs\Current-ScriptLog.txt"
$PWLogLocation = ("C:\Scripts\Logs\" + $Dates + "-PWLog" + ".txt")
$smtpServer= "192.168.10.15"
$expireindays = 10
$imgpath = "C:\Scripts\Images"
$HTMLpath = "C:\Scripts"

Try
{
	Import-Module ActiveDirectory
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"Import AD module attempted. Error was '$errorMessage' on item $errorItem." | Out-Default
    Stop-Transcript
    Exit
}

Try
{
	$smtp = new-object Net.Mail.SmtpClient($smtpServer)
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"Attempted to instantiate email module. Error was '$errorMessage' on item $errorItem."  | Out-Default
	Stop-Transcript
    Exit
}

Try
{
	#Build email with from, inline images, and body
	$msg = new-object Net.Mail.MailMessage
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"Attempt to create email. Error was '$errorMessage' on item $errorItem." | Out-Default
    Stop-Transcript
    Exit
}
$msg.From = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
$msg.ReplyTo = "The ManagedIron Help Desk <DoNotReply@triconenergy.com>"
$msg.IsBodyHtml = $True

Try
{
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
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"Attempted to add attachments to email. Error was '$errorMessage' on item $errorItem." | Out-Default
    Stop-Transcript
    Exit
}

Try
{
	$msg.body = get-content -Path $HTMLPath\PasswordChangeInstructions.htm
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"Attempted to access email body content. Error was '$errorMessage' on item $errorItem." | Out-Default
    Stop-Transcript
    Exit
}

#uncomment line 98, change email to appropriate address and comment lines 132-142, with <# #>, for testing
#$emailaddress = "dbrown@ironedgegroup.com"

#Get Users From AD who are enabled, password set to expire, and have an email address
Try
{
	#$users = Get-ADUser -Server TRI-COLO-DC03 -filter * -properties * | Where {$_.Enabled -eq "True"} | Where { $_.PasswordNeverExpires -eq $false } | Where { $_.passwordexpired -eq $false } | Where { $_.emailaddress -ne $null }
    #modified query as there were periodic timeouts with the get-aduser
    #filtered the query itself as seen in next line as opposed to filtering the results as seen above
    $users = Get-ADUser -Server TRI-COLO-DC03 -LDAPFilter '(&(objectCategory=person)(objectClass=user)(mail=*)(!userAccountControl:1.2.840.113556.1.4.803:=2)(!userAccountControl:1.2.840.113556.1.4.803:=65536))' -Properties * | Where { $_.passwordexpired -eq $false }
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"User list attempted. Error was '$errorMessage' on item $errorItem ." | Out-Default
    Stop-Transcript
    Exit
}
	
#add subject and recipient, send email, then clear subject and recipient in prep for next user
foreach ($user in $users)
{
    Try
	{
		$Name = (Get-ADUser $user | foreach { $_.Name})
	}
	Catch
	{
		$errorMessage = $_.Exception.Message
		$errorItem = $_.Exception.ItemName
		"Attempted to extract name for $user. Error was '$errorMessage' on item $errorItem." | Out-Default
		Continue
	}
	
    Try
	{
		$emailaddress = $user.emailaddress
	}
	Catch
	{
		$errorMessage = $_.Exception.Message
		$errorItem = $_.Exception.ItemName
		"Attempted to extract email for $user. Error was '$errorMessage' on item $errorItem." | Out-Default
		Break
	}
	
    Try
	{
		$passwordSetDate = (Get-ADUser $user -properties * | foreach { $_.PasswordLastSet })
	}
	Catch
	{
		$errorMessage = $_.Exception.Message
		$errorItem = $_.Exception.ItemName
		"Attempted to get AD user properties for $user. Error was '$errorMessage' on item $errorItem." | Out-Default
		Continue
	}
	
    Try
	{
		$PasswordPol = (Get-AduserResultantPasswordPolicy $user)
	}
	Catch
	{
		$errorMessage = $_.Exception.Message
		$errorItem = $_.Exception.ItemName
		"Attempted to get Password policy for user $user. Error was '$errorMessage' on item $errorItem." | Out-Default
		Continue
	}
	

    # Check for Fine Grained Password
    if (($PasswordPol) -ne $null)
    {
        $maxPasswordAge = ($PasswordPol).MaxPasswordAge
    }
    else
    {
        Try
		{
			$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
		}
		Catch
		{
			$errorMessage = $_.Exception.Message
			$errorItem = $_.Exception.ItemName
			"Attempted to get max password age for $user. Error was '$errorMessage' on item $errorItem." | Out-Default
			Continue
		}
    }
    
	$expireson = $passwordsetdate + $maxPasswordAge
	#write-output "Password expires on $expireson"
	$today = (get-date)
	Try
	{
		$daystoexpire = (New-TimeSpan -Start $today -End $Expireson).Days
	}
	Catch
	{
		$errorMessage = $_.Exception.Message
		$errorItem = $_.Exception.ItemName
		"Attempted to set days to expire for $user. Error was '$errorMessage' on item $errorItem."  | Out-Default
		Continue
	}
	
	if ($daystoexpire -lt $expireindays)
	{
		$msg.subject="$Name, your password will expire in $daystoexpire days."
		$msg.To.Add($emailaddress)
		$smtp.Send($msg)
		$msg.To.Remove($emailaddress)
		$msg.Subject.Clear

		write-output "$Name will be sent an email for password expiry, $daystoexpire days till expiration" | Out-File -FilePath $PWLogLocation -Append
	}
}

#cleanup email before ending
$attachment.dispose();
$msg.dispose();

#Remove-Item $CurrentScriptLogLocation
New-Item -ItemType File -Path $CurrentScriptLogLocation -Force
Try
{
	Copy-Item -Path $ScriptLogLocation -Destination $CurrentScriptLogLocation -Force
}
Catch
{
	$errorMessage = $_.Exception.Message
	$errorItem = $_.Exception.ItemName
	"Attempted to copy script log file. Error was '$errorMessage' on item $errorItem."  | Out-Default
	Break
}

Stop-Transcript