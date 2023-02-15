$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -AllowClobber



function Get-AllMailboxPermissions {
    $allMailboxes = Get-Mailbox -ResultSize Unlimited | Sort-Object Identity

    if ($allMailboxes.Count -eq 0) {
        Write-Warning "No mailboxes found."
        return
    }
    foreach ($box in $allMailboxes) {
        $perms = $box | Get-MailboxPermission |
                        Where-Object { $_.IsInherited -eq $false -and $_.User.ToString() -ne "NT AUTHORITY\SELF" -and $_.User.ToString() -notmatch '^S-1-' } |
                        Sort-Object User

        foreach ($prm in $perms) {
            $user = Get-Recipient -Identity $($prm.User.ToString()) -ErrorAction SilentlyContinue
            # skip inactive (deleted) users
            if ($user -and $user.DisplayName) { 
                $props = [ordered]@{
                    "Mailbox Identity"      = "$($box.Identity)"
                    "Mailbox Name"      = "$($box.displayname)"
                    "Mailbox Email Address"      = "$($box.PrimarySmtpAddress)"
                    "User"         = $user.DisplayName
                    "User Email Address"         = $user.PrimarySmtpAddress
                    "Department" = $user.department
                    "Job Title" = $user.title
                    "AccessRights" = "$($prm.AccessRights -join ', ')"
                    

                }
                New-Object PsObject -Property $props
            }
        }
    }
}

cls
Get-AllMailboxPermissions | export-csv -NoTypeInformation c:\temp\mailboxpermissionsreport.csv




