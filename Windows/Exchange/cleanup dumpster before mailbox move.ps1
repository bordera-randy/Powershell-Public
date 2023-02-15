#Set quotas to 0KB
Set-Mailbox dave -RecoverableItemsQuota 0KB -RecoverableItemsWarningQuota 0KB -UseDatabaseQuotaDefaults $false
Start-ManagedFolderAssistant dave

#Now perform a search and destroy on the users dumpster:
Search-Mailbox dave -searchdumpsteronly -deletecontent -confirm:$false -Force

#After moving the mailbox, change it back to inherit the database defaults:
Set-Mailbox dave -UseDatabaseQuotaDefaults $true