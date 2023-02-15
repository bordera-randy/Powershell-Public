$Output = “C:\exchangescripts\ExchangeOutPut.txt”
$Databases = Get-MailboxDatabase
foreach ($DB in $Databases)
{
[string]$logPathString = $db.LogFolderPath
$MyDriveString =$logPathString.substring(0,1);
$MySubString=$logPathString.substring(0,2);
$UNCPath = “\\$($db.Server)\” + $MyDriveString + “$” ;
$Logfoldername = $logPathString.Replace($MySubString,$UNCPath);
Write-Output $Logfoldername
$Logfoldername | Out-File $Output -append
foreach ($Log in $Logfoldername)
{
$LogCount = dir $Log | group {$_.LastWriteTime.ToShortDateString()} | select Name,Count
Write-Output $LogCount
$LogCount | Out-File $Output -append
}
}