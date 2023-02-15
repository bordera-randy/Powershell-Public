# GPOBackupSamp.PS1  
# Script By: Tim B. 
# This script Backup all GPOs and save it to a folder named as the current date. 
# Change the Path "\\server\c$\Backup\GroupPolicies\$date" to your server path 
 
Import-Module grouppolicy 
$date = get-date -format M.d.yyyy-HH.mm.ss
New-Item -Path c:\support\GPBackup\$date -ItemType directory 
Backup-Gpo -All -Path c:\support\GPBackup\$date