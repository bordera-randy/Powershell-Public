

$user       = 
$password   =   
$path       = 'C:\iis-config-backup'
$logfile    = 'C:\iis-config-backup\iis-config.log'


import-module webadministration

mkdir $path
Copy-Item "C:\Windows\System32\inetsrv\config\applicationhost.config" -Destination $path
Get-ChildItem -Path 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\' | where Name -like '6de9cb26d2b98c01ec4e9e8b34824aa2_*' | Move-Item -Destination $path
Get-ChildItem -Path 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\' | where Name -like 'd6d986f09a1ee04e24c949879fdb506c_*' | Move-Item -Destination $path
Get-ChildItem -Path 'C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\' | where Name -like '76944fb33636aeddb9590521c2e8815a_*' | Move-Item -Destination $path

<# delete certificate #>

<# Request new certificate #>

<# Set IIS binding port 443 #>

C:\Windows\system32\inetsrv\iissetup.exe /install SharedLibraries


<# 
$iis = get-ItemProperty iis:\apppools\*

foreach($i in $iis) {
Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
start-webapppool

}

#>




get-ItemProperty iis:\apppools\Claims.Help.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Claims.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Claims.WCF.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Consoles.Help.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\DEV22_InsightsApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\DuckCreekBillingApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\DuckCreek-Messaging | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\DuckCreekPolicyApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\ExpressBillingApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\ExpressPolicyApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\InsightsApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Party.Consoles.Help.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Party.Consoles.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Party.Styles.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Party.WCF.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\ServerBalancingApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\ServerExtractApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Styles.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\UserAdminBillingApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\UserAdminPolicyApp | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
get-ItemProperty iis:\apppools\Claims.Consoles.Pool | Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }

start-webapppool -name Claims.Consoles.Pool
Start-WebAppPool -Name Claims.Help.Pool
Start-WebAppPool -Name Claims.Pool
Start-WebAppPool -Name Claims.WCF.Pool
Start-WebAppPool -Name Consoles.Help.Pool
Start-WebAppPool -Name DEV22_InsightsApp
Start-WebAppPool -Name DuckCreekBillingApp
Start-WebAppPool -Name DuckCreek-Messaging
Start-WebAppPool -Name DuckCreekPolicyApp
Start-WebAppPool -Name ExpressBillingApp
Start-WebAppPool -Name ExpressPolicyApp
Start-WebAppPool -Name InsightsApp
Start-WebAppPool -Name Party.Consoles.Help.Pool
Start-WebAppPool -Name Party.Consoles.Pool
Start-WebAppPool -Name Party.Styles.Pool
Start-WebAppPool -Name Party.WCF.Pool
Start-WebAppPool -Name ServerBalancingApp
Start-WebAppPool -Name ServerExtractApp
Start-WebAppPool -Name Styles.Pool
Start-WebAppPool -Name UserAdminBillingApp
Start-WebAppPool -Name UserAdminPolicyApp 




<#
foreach($i in $iis) {
Set-ItemProperty -name processModel -value @{userName=$user; password=$password; identitytype=3 }
start-webapppool

}

#>
                          


# IIS Certificate 443
