<#
.SYNOPSIS
Enables Outlook automapping on mailboxes where users have been given full access rights.

Author/Copyright:    Jeff Guillet, MCSM | MVP - All rights reserved
Email/Blog/Twitter:  jeff@expta.com | www.expta.com | @expta

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

.NOTES
Version 1.0, January 23, 2019

Revision History
---------------------------------------------------------------------
1.0	Initial release
	
.DESCRIPTION
Enables Outlook automapping on mailboxes where users have been given full access rights.

Automapping is enabled by default whenever a user is given full access rights on a mailbox, but this can be disabled. This script re-enables automapping. This is useful before converting a user mailbox to a shared mailbox.

.PARAMETER Mailbox
Specifies the Exchange mailbox to configure for automapping.

.PARAMETER Mailbox
Specifies the mailbox to process.

.LINK
http://blog.expta.com

.EXAMPLE
PS C:\>Enable-AutomappingForFullAccessMailboxes.ps1 TeamMailbox

This command enables Outlook automapping for all users who have Full Access rights to the TeamMailbox mailbox.

.EXAMPLE
PS C:\>Enable-AutomappingForFullAccessMailboxes.ps1

This command enables Outlook automapping for all users who have Full Access rights to any mailbox in the organization.
#>

# Define the script parameters
Param (
	[Parameter(Mandatory=$false)]
	[string]$Mailbox
)

Process {
	if ($mailbox -ne "") {
		$mailboxes = Get-Mailbox $mailbox -ResultSize unlimited | where {$_.RecipientTypeDetails -eq "UserMailbox"}
	} else {
		$mailboxes = Get-Mailbox -ResultSize unlimited | where {$_.RecipientTypeDetails -eq "UserMailbox"}
	}
	foreach ($mailbox in $mailboxes) {
		$delegates = Get-MailboxPermission $mailbox | where {$_.AccessRights -contains "fullaccess" -and $_.IsInherited -eq $false}
		foreach ($delegate in $delegates) {
			Write-Host "Processing $mailbox..." -ForegroundColor Cyan
			Add-MailboxPermission -Identity $mailbox -User $delegate.User -AccessRights FullAccess -AutoMapping $true
		}
	}
}