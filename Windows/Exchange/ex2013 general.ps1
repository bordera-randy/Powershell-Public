Get-MailboxDatabaseCopyStatus MB0* | ft -a
Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed"}
Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed"} | Update-MailboxDatabaseCopy -CatalogOnly

Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus | where {$_.Status -eq “FailedandSuspended”}| Resume-MailboxDatabaseCopy
Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus | where {$_.Status -eq “Suspended”}| Resume-MailboxDatabaseCopy
Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus | where {$_.Status -eq “Failed”}| Resume-MailboxDatabaseCopy

Get-MoveRequest | Get-MoveRequestStatistics | ft displayname,statusdetail,totalmailboxsize,bytestransferred,bytestransferredperminute,percentcomplete,sourcedatabase,targetdatabase -a
Get-MigrationUser | Get-MigrationUserStatistics | ft identity,batchid,status,percentagecomplete,estimatedtotaltransfersize,CurrentBytesTransferredPerMinute -a

get-moverequest -movestatus Completed | remove-moverequest

get-mailbox -Database MB02 | Get-MailboxStatistics | ft displayname,itemcount,totalitemsize -a

