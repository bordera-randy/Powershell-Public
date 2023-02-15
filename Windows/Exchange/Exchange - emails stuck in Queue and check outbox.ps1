

##########################################################################################################################
#     Name: Exchange - emails stuck in Queue and check outbox
#     Date Created: 8/8/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will retry messages stuck in the queue without sending NDR and create a file with a list of mailboxes with messages stuck in the outbox
#
##########################################################################################################################

#########################################
#              Variables
#########################################

$Servers = "CAS01","CAS02" # Enter the name of all CAS servers


#########################################
#              Create Folder
#########################################

mkdir C:\exchangescripts\

#########################################
#              Load Exchange SnapIn
#########################################

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

#########################################
#              Find mailboxes with items stuck in Outbox
#########################################

Get-Mailbox -ResultSize Unlimited | Get-MailboxFolderStatistics | Where-Object {$_.Name -eq "Outbox" -and $_.ItemsInFolder -gt '0' } | Select-Object Identity, FolderType, ItemsinFolder, FolderSize | Export-CSV "C:\exchangescripts\Outbox.csv"

#########################################
#              Empty Exchange retry queues without NDR
#########################################

foreach ($server in $servers)
{
$retryqueues = get-queue -Server $server -filter {Status -eq "Retry"}
foreach ($queue in $retryqueues)
{
Get-Message -Queue $queue.identity | Remove-Message -WithNDR $false -Confirm:$false
}
}

