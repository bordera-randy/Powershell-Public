# Simple ROBOCOPY backup script written by Mike Avelar
# Date: 2014-01-21
# Version: 1.0

Write-Host -ForegroundColor DarkCyan "Backup with PowerShell by Mike Avelar";

Write-Host -ForegroundColor Cyan "Setting variables...";

$strMassDrive = "E:";
$strBackupDrive = "X:";

#Specific libraries from my USERPROFILE
$strPicturesLibrary = ($env:USERPROFILE + "\Pictures");
$strDownloads = ($env:USERPROFILE + "\Downloads");

#My SWTOR Settings (UI settings)
$strSWTORSettings = ($env:LOCALAPPDATA + "\SWTOR\swtor\settings");

#Games and Video Files so I don't have to download them again
$strOriginGames = ("Origin Games");
$strSteamGames = ("SteamLibrary");
$strVideoFiles = ("Video Files");

Write-Host -ForegroundColor Cyan "Setting Arrays...";

$argsFromFolders = ($strPicturesLibrary, $strDownloads, $strSWTORSettings, "$strMassDrive\$strOriginGames", "$strMassDrive\$strSteamGames", "$strMassDrive\$strVideoFiles");
$argsToFolders = ("$strBackupDrive\Pictures", "$strBackupDrive\Downloads", "$strBackupDrive\SWTOR", "$strBackupDrive\$strOriginGames", "$strBackupDrive\$strSteamGames", "$strBackupDrive\$strVideoFiles");

For ($i=0; $i -lt $argsFromFolders.Length; $i++) {
    Write-Host -ForegroundColor Green "Processing" $argsFromFolders[$i] "To" $argsToFolders[$i];
    #Robocopy Paramters are as follows:
    # /S :: copy Subdirectories, but not empty ones.
    # /MT[:n] :: Do multi-threaded copies with n threads (default 8).
    #            n must be at least 1 and not greater than 128.
    #            This option is incompatible with the /IPG and /EFSRAW options.
    #            Redirect output using /LOG option for better performance.
    # /XJ :: eXclude Junction points. (normally included by default).
    # /R:n :: number of Retries on failed copies: default 1 million.
    # /NP :: No Progress - don't display percentage copied.
    robocopy $argsFromFolders[$i] $argsToFolders[$i] *.* /S /MT:16 /XJ /R:0 /W:5 /NP /XX
    }

Write-Host -ForegroundColor DarkGreen "Robocopy processes have completed."
Pause