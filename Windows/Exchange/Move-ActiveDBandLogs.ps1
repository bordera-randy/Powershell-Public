#This needs to be run on the server hosting the active databases
$dmdbs = Get-MailboxDatabase -status | Where ({$_.ReplicationType -eq "None" -and $_.Identity -like "DBTest*" -and $_.Mounted -eq $false}) | select Identity,Name
$mdbs = Get-MailboxDatabase -status | Where ({$_.ReplicationType -eq "None" -and $_.Identity -like "DBTest*" -and $_.Mounted -eq $true}) | select Identity,Name,Mounted
Write-Host "Verifing DBs are still dismounted"
#Step 6: Check if DB is mounted and dismount it (passed)
foreach ($mdb in $mdbs) {
    Dismount-Database -identity $mdb.Identity -confirm:$false
    }
Write-Host "Looks good, continuing"
Write-Host 
Write-Host "Copying ACTIVE logs to their new home"
#Step 7: Move ACTIVE logs to their new drives (passed)
Foreach ($dmdb in $dmdbs) {
   #Move just the logs
   #Test write-host $dmdb.Identity
   $DLtr = "L:\"
   $Fldr = $dmdb.Name
   $LFP = $DLtr+$Fldr
   Move-DatabasePath -Identity $dmdb.Identity -LogFolderPath $LFP -Confirm:$false
    }
Write-Host "Logs have been moved"
Write-Host
Write-Host "Moving MDB05 to its new home"
#Step 8: Move DBTest2 to their new drives (passed)
Move-DatabasePath -Identity  -EdbFilePath E:\mdb05\mdb05.edb -Confirm:$false
Write-Host "DB have been moved"
#Step 9: Mount ALL active databases
Foreach ($dmdb in $dmdbs) {
    #mount All DB's
    Mount-Database -Identity $dmdb.Name -Confirm:$false
    }
#Go back to passive server and execute Cleanup-Tasks.ps1