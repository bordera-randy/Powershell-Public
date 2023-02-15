$path       = 'C:\iis-config-backup'
$logfile    = 'C:\iis-config-backup\iis-config.log'
mkdir $path
Copy-Item "C:\Windows\System32\inetsrv\config\*.config" -Destination $path

Get-ChildItem -Path 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\' | where Name -like '6de9cb26d2b98c01ec4e9e8b34824aa2_*' | Move-Item -Destination $path
Get-ChildItem -Path 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\' | where Name -like 'd6d986f09a1ee04e24c949879fdb506c_*' | Move-Item -Destination $path
Get-ChildItem -Path 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\' | where Name -like '76944fb33636aeddb9590521c2e8815a_*' | Move-Item -Destination $path
