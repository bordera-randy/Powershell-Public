#DB Test to be run on HOUDCEX02
Clear
$cldbs = Get-MailboxDatabase | where {$_.CircularLoggingEnabled -eq $true} | select Identity
$adbs = Get-MailboxDatabaseCopystatus | where {$_.Status -eq "Mounted"} | select databasename,Identity #Mounted = Active Copy
$pdbs = Get-MailboxDatabaseCopystatus | where {$_.Status -eq "Healthy"} | select databasename,Identity #Healthy = Passive Copy
Write-Host "Attempting to disable circular logging"
# Step 1: Disable Circular Logging (Passed)
Get-MailboxDatabase | where {$_.CircularLoggingEnabled -eq $true} | set-mailboxdatabase -CircularLoggingEnabled:$false
Write-Host "Circular Logging Disabled"
#Step: 2: Activate Database on specific Exchange Server (Passed)
foreach ($adb in $adbs) {
    Move-ActiveMailboxDatabase $adb.databasename -ActivateOnServer HOUDCEX01 -MountDialOverride:None
        }
Write-Host "All DBs are active on HOUDCEX01"
#Step 3: Remove all mailbox database copies (passed)
Get-MailboxDatabaseCopystatus | where {$_.Status -eq "Healthy"} | Remove-MailboxDatabaseCopy -Confirm:$false
Write-Host "Passive DB copies removed"
#Step 4: Dismount Databases (Passed)
$dbs = Get-MailboxDatabase | where {$_.ReplicationType -eq "None"} | select Identity
foreach ($db in $dbs) {
    #Testing Write-host $db.Identity
    Dismount-Database -Identity $db.Identity -confirm:$false
    sleep -Seconds 2
    }
Write-Host "DBs are now DISMOUNTED"
#Step 5: RoboCopy all database and log file copies to their new drives (Passed)
    Write-Host "5 minute cooldown to system will release files"
    sleep -Seconds 300
    #Robocopy Log Files
        robocopy.exe d:\log\mdb06 l:\mdb06 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\mdb06_log.txt
        robocopy.exe d:\log\mdb05 l:\mdb05 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\mdb05_log.txt
        robocopy.exe d:\log\mdb07 l:\mdb07 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\mdb07_log.txt
        robocopy.exe D:\log\PFDB03 l:\PFDB03 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\pfdb03_log.txt
        robocopy.exe H:\Database\PLG_EXDB18\Logs l:\PLG_EXDB18 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\plg_exdb18_log.txt
        robocopy.exe F:\logs\Archive_DB01 l:\Archive_DB01 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\archive_db01_log.txt
        robocopy.exe F:\Database\PLG_EXDB05\Logs l:\PLG_EXDB05 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\plg_exdb05_log.txt
        robocopy.exe F:\Database\PLG_EXDB01\Logs l:\PLG_EXDB01 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\plg_exdb01_log.txt
        robocopy.exe F:\Database\PLG_EXDB02\Logs l:\PLG_EXDB02 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\plg_exdb02_log.txt
    #Robocopy all database copies to their new drives
        robocopy.exe d:\database\mdb05\ e:\MDB05 /E /ZB /DCOPY:DAT /COPYALL /R:5 /W:10 /Log:c:\temp\mdb05_db.txt
Write-Host "Robocopy Complete"
#Step 6: Move Active DBs and Logs should be run on server hosting the active/mounted copies (passed)