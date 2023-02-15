## Connect to office 365
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

# 
foreach($user in Get-Mailbox -RecipientTypeDetails UserMailbox) {
$cal = $user.alias+":\Calendar"
get-MailboxFolderPermission -Identity $cal -user default | select identity, foldername, user, accessrights
}