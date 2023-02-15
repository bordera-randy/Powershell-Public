<#
.SYNOPSIS
    Script checks MailboxPermissions and MailboxFolderPermissions and copy this permissions to other user.
.DESCRIPTION
    Checks the MailboxPermission and MailboxFolderPermission from specified user on all mailboxes and copy the 
    permission entry to the specified target user, with -automapping:$true. Very useful if a user has access to many 
    mailboxes and calendars and you want to copy this permission to a another user.
.EXAMPLE
    PS C:\> Copy-MailboxPermissions -SourceMailbox <username> -DestinationMailbox <username> -CopyMailboxFolderPermission
.PARAMETER SourceMailbox
    Specify the mailbox wich permissions must be checked on the other mailboxes. These permissions wil be copied.
.PARAMETER DestinationMailbox
    Specify the target mailbox where the rights to which the rights are to be copied and assigned.
.PARAMETER CopyMailboxFolderPermission
    This paramter is a switch. If you set this switch to $true it wil also copy the MailboxFolderPermissions
    from te source user to the target user.
.PARAMETER ComputerName
    To run this script from remote, enter a hostname or a IP-address from the Exchange Server
    to create a remote Powershell Session. Very useful for project scripts.
.NOTES
    Name:       Martien van Dijk
    Date:       30-08-2018
    Version:    1.0.1

    Changelog
    1.0.1 (30-08-2018)
    - Add try/catch on import pssession
    - adding some console logging with write-host on try/catch on import pssession.
    1.0 (28-08-2018)
    - Initial script creation
.LINK
    Check my blog:  https://windowstechblog.nl - It's all about Microsoft
#>

function Copy-MailboxPermissions {
    [CmdletBinding()]
    param (
        # Enter the Mailbox for the template
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Specify the UserMailbox for the template."
        )]
        [string]
        $SourceMailbox,

        # Enter the Mailbox as a copy destination
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Enter the Mailbox as a copy destination."
        )]
        [string]
        $DestinationMailbox,

        [parameter(
            Mandatory = $false,
            HelpMessage = "If the MailboxFolderPermissions for this user must be copied. Use this switch."
        )]
        [switch]
        $CopyMailboxFolderPermission,

        [parameter(
            Mandatory = $false,
            HelpMessage = "Enter hostname. FQDN or IP-address from Exchange server to run this cmdlet remotely."
        )]
        [string]
        $ComputerName     
    ) # End param
    
    begin {
        $ErrorActionPreference = "SilentlyContinue"

        # Determine if server is Exchange Server
        $MSExchangeHost = (Get-service -Name MSExchangeServiceHost)
        if (!($MSExchangeHost)) {
            if (!($ComputerName)) {
                Write-Warning "$env:computername is not a Exchange Server. You need to use 'ComputerName' parameter to connect to a Exchange Server. Script is terminating in 5 seconds."
                sleep 5
                break
            }
        }

        # Checks if there is already a PSSession to a Exchange Server
        if (!(Get-PSSession | ? { 
                    $_.ConfigurationName -eq "Microsoft.Exchange" })) {
            Write-Host "Connecting to Exchange Server. Please wait..." -f Yellow
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ComputerName/PowerShell/ -Authentication Kerberos
        } try {
            Import-PSSession $Session -DisableNameChecking
            Write-Host "Powershell is connected with Exchange. Script will continue execution..." -f Green
        }
        Catch {
            $error.Clear()
            $ErrorMessage = $_.Exception.Message
            Write-Host "Error: $ErrorMessage" -f Red
            break
        }
        
    } # End Begin 

    process {
        $Mperms = Get-mailbox -resultsize unlimited | Get-MailboxPermission -user $SourceMailbox
        $Mperms | % {
            try {
                Add-MailboxPermission $_.identity -accessrights $_.accessrights -user $destinationmailbox -automapping:$true
            }
            Catch {
                $error.Clear()
                $ErrorMessage = $_.Exception.Message
                Write-Host "Error: $ErrorMessage" -f Red
            }
        }
        if ($CopyMailboxFolderPermission) {
            $MFperms = get-mailbox -resultsize unlimited | % {
                Get-MailboxFolderPermission ($_.samaccountname + ":\calendar") -user $SourceMailbox -ea silentlycontinue
            }
            $MFperms | % {
                try { 
                    Add-MailboxFolderPermission $_.identity -User $destinationmailbox -AccessRights $_.accessrights 
                }
                Catch {
                    $error.Clear()
                    $ErrorMessage = $_.Exception.Message
                    Write-Host "Error: $ErrorMessage" -f Red  
                }
            }
        }
    }
        
    end {
        # Close Powershell Session if available
        if ($session) {
            try {
                Remove-PSSession $Session
            }
            Catch {
                $error.Clear()
                $ErrorMessage = $_.Exception.Message
                Write-Host "Error: $ErrorMessage" -f Red  
            }
        }
    }
} # End function
