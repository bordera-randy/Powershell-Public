
##########################################################################################################################
#     Name: Mailbox Tickler
#     Date Created: 8/20/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will connect to the Office 365 and force updataes to mailboxes to triffer address list updates
#
##########################################################################################################################


#############
# Variables #
#############

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#############
# Main      #
#############


Import-PSSession $Session -AllowClobber





$mailboxes = Get-Mailbox -Resultsize Unlimited
$count = $mailboxes.count
$i=0

Write-Host
Write-Host "Mailboxes Found:" $count

foreach($mailbox in $mailboxes){
  $i++
  Set-Mailbox $mailbox.alias -SimpleDisplayName $mailbox.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Tickling Mailboxes [$count]..." -Status $i
}

$mailusers = Get-MailUser -Resultsize Unlimited
$count = $mailusers.count
$i=0

Write-Host
Write-Host "Mail Users Found:" $count

foreach($mailuser in $mailusers){
  $i++
  Set-MailUser $mailuser.alias -SimpleDisplayName $mailuser.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Tickling Mail Users [$count]..." -Status $i
}

$distgroups = Get-DistributionGroup -Resultsize Unlimited
$count = $distgroups.count
$i=0

Write-Host
Write-Host "Distribution Groups Found:" $count

foreach($distgroup in $distgroups){
  $i++
  Set-DistributionGroup $distgroup.alias -SimpleDisplayName $distgroup.SimpleDisplayName -WarningAction silentlyContinue
  Write-Progress -Activity "Tickling Distribution Groups. [$count].." -Status $i
}

Write-Host
Write-Host "Tickling Complete"