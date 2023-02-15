[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name PSWindowsUpdate
Import-Module -Name PSWindowsUpdate
Get-WindowsUpdate -NotKBArticleID "KB5003638" -AutoReboot -Install -ForceInstall
