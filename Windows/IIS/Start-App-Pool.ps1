<########################################################################################################################################################
    Name: DCOD-AppPoolStart
    Author: Randy Bordeaux
    Date Created: 8/3/2021
    Date Modified:
    
    Description: 
        This will find all the app pools and start them. 
        
    Requirements: 
        webadministartion module 
        
    Documentation: 
        
########################################################################################################################################################>

import-module webadministration
foreach ($AppPoolName in $AppPoolNameList)
{
Write-Host "---"
Write-Host AppPool: $AppPoolName
$temp = Get-ItemProperty "IIS:\AppPools\$AppPoolName"
Write-Host "Starting" $apppoolname
start-webapppool -name $AppPoolName
$state = Get-WebAppPoolState -Name $AppPoolName
Write-host -f Cyan $temp.name "has" $state.Value
Write-Host " "
}
