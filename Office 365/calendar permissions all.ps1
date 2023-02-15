$credentials = Get-Credential
Write-Output “Getting the Exchange Online cmdlets”

$Session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-ConfigurationName Microsoft.Exchange -Credential $credentials `
-Authentication Basic -AllowRedirection
Import-PSSession $Session

foreach($user in Get-Mailbox -RecipientTypeDetails UserMailbox) {

$cal = $user.alias+”:\Calendar”

Set-MailboxFolderPermission -Identity $cal -User Default -AccessRights LimitedDetails

}