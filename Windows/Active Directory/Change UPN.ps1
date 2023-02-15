



##########################################################################################################################
#     Name: Change UPN
#     Date Created: 8/14/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will change the UPN for all users.
#
##########################################################################################################################


#############
# Variables #
#############
Write-Host -ForegroundColor yellow -BackgroundColor red "Loading Variables..."
$oldSuffix = "canitpro.local"
$newSuffix = "rebeladmin.com"
$ou = "DC=canitpro,DC=local"
$server = "DCM1"


#############
# Modules   #
#############
Write-Host -ForegroundColor yellow -BackgroundColor red "Importing Active Directory Module..."
Import-Module ActiveDirectory

#############
# Main      #
#############
cls
Write-Host -ForegroundColor yellow -BackgroundColor red "Updating UPN for all users...."
Get-ADUser -SearchBase $ou -filter * | ForEach-Object {
$newUpn = $_.UserPrincipalName.Replace($oldSuffix,$newSuffix)
$_ | Set-ADUser -server $server -UserPrincipalName $newUpn


Write-Host -ForegroundColor yellow -BackgroundColor red "UPN update has been completed."