Write-Host "====Script Started====="

Import-module webadministration

$ServiceAccount = "DEV\BiBerkDEV.app.user"
$NewIdentity = "DEV\BiBerkDEV.app.user"
$NewPassword = ""

$AppPoolNameList = @()

Write-Host "Retreiving all AppPools for the following Identity: " $ServiceAccount

foreach ($AppPool in (Get-ChildItem –Path IIS:\AppPools | select Name))
{
$name = $AppPool.name
$AppPoolObJ = Get-ItemProperty IIS:\AppPools\$name
if($AppPoolObJ.processModel.userName -eq $ServiceAccount)
{
$AppPoolNameList += $AppPoolObJ.name
}
}

Write-Host "Number of AppPools Found for Identity: " $AppPoolNameList.Count

Write-Host "------------"

foreach ($AppPoolName in $AppPoolNameList)
{

 Write-Host "---"
Write-Host AppPool: $AppPoolName
$temp = Get-ItemProperty "IIS:\AppPools\$AppPoolName"
Write-Host "Current App Pool Identity: " $temp.processModel.userName
Write-Host "Attempting to change Identity..."
Set-ItemProperty IIS:\AppPools\$AppPoolName -name processModel -value @{userName=$NewIdentity;password=$NewPassword;identitytype=3}
Write-Host "Current App Pool Identity: " $temp.processModel.userName
if($temp.processModel.userName.ToUpper() -eq $NewIdentity.ToUpper()){Write-Host "Success"}else{Write-Host "Failure"}
write-host "Starting App Pool '$apppoolname'"
start-webapppool -name $AppPoolName
$temp
Write-Host "---"
}

Write-Host "------------"

Write-Host "====Script Finished====="
