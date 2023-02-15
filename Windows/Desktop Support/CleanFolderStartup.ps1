#####################################################
<#
.SYNOPSIS   
Script do remove files in Startup Folder running with Windows 7
    
.DESCRIPTION 
The script removes files that are inside the User folder initializing , running windows 7
	


.NOTES   
Name: CleanFolderStartup.ps1
Author: Diego Alves da Silva
Version: 1.1.1
DateCreated: 2016-06-06



#>

Set-ExecutionPolicy Unrestricted

######GET USER Domain######
$user=whoami
######Remove Domain Name Netbios##########
$user=$user.Replace("domainNameNetbios\","")
######User enters name in variable $listuser########
$listuser = "$user"
######List contents of C: \ users###################
$dir = "C:\Users"
######Select the folder of the logged User##########
$latest = Get-ChildItem -Path $dir | Where-Object {$_.Name -like $listuser}
$latestfull = $latest.FullName
######Select the Startup folder of the logged User##
$getinic = "$latestfull"+"\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
######Remove the files in the Startup folder########
Remove-Item $getinic\* -force -Recurse