########################################################################################
#
#    Created by: Nathan Carlson
#    Updated: 09/01/2017
#    Updated by: Randy Bordeaux
#
#    Description:
#    This script downloads and installs the latest version of the following software:
#
#    Java (x86 and x64)
#    Adobe Reader DC
#    7-Zip
########################################################################################

#Remove Window 10 Apps

Get-AppxPackage -allusers *messaging* | remove-appxpackage
Get-AppxPackage -allusers *sway* | remove-appxpackage
Get-AppxPackage -allusers *phone* | remove-appxpackage
Get-AppxPackage -allusers *communicationsapps* | remove-appxpackage 
Get-AppxPackage -allusers *people* | remove-appxpackage 
Get-AppxPackage -allusers *zune* | remove-appxpackage 
Get-AppxPackage -allusers *bing* | remove-appxpackage 
Get-AppxPackage -allusers *onenote* | remove-appxpackage 
Get-AppxPackage -allusers *alarms* | remove-appxpackage 
Get-AppxPackage -allusers *maps* | remove-appxpackage 
Get-AppxPackage -allusers *xbox* | remove-appxpackage 
Get-AppxPackage -allusers *soundrecorder* | remove-appxpackage 
Get-AppxPackage -allusers *officehub* | remove-appxpackage 
Get-AppxPackage -allusers *skypeapp* | remove-appxpackage 
Get-AppxPackage -allusers *3dbuilder* | remove-appxpackage 

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

echo "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

echo "Uninstalling default apps"
$apps = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Office.OneNote"
    #"Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    #"Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    #"Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "microsoft.windowscommunicationsapps"
    "Microsoft.MinecraftUWP"

    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"

    # non-Microsoft
    "9E2F88E3.Twitter"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "king.com.*"
    "ClearChannelRadioDigital.iHeartRadio"
    "TheNewYorkTimes.NYTCrossword"
)

foreach ($app in $apps) {
    echo "Trying to remove $app"

    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage

    Get-AppXProvisionedPackage -Online |
        where DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online
}

# Create C:\Temp if it doesn't exist
Write-Host "Creating C:\Temp"
New-Item C:\Temp -Type directory -Force

# Install .NET Framework 3.5
Write-Host "Installing .NET Framework 3.5..."
Add-WindowsCapability –Online -Name NetFx3~~~~

# Install Applications via Ninite Pro
Write-Host "Installing apps via Ninite Pro..."
$client.DownloadFile("http://automate.managediron.com/labtech/transfer/scripts/mp/ninite/niniteone.exe", "C:\Temp\niniteone.exe")
cmd /c 'C:\Temp\niniteone.exe /select Reader Java "Java x64" 7-Zip /silent NiniteLog.txt'

# Remove all items used
Write-Host "Removing downloaded items"
Remove-Item "C:\Temp\niniteone.exe"

Write-Host "Complete"