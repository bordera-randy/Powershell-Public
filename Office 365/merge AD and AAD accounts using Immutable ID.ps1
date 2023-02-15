
##########################################################################################################################
#     Name: Merge Active Directory Accounts
#     Date Created: 8/20/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will disable Directory Sync and allow you to change sync'd account Immutable ID's
#
##########################################################################################################################


#############
# Variables #
#############

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#############
# Main      #
#############

Import-PSSession $Session -AllowClobber
Install-Module MSOnline 
Import-Module MSOnline 

##########################
# Disable Directory Sync #
##########################

Set-MsolDirSyncEnabled -EnableDirSync $false

#########################################
# Connect to MSOL service on PowerShell #
#########################################

Connect-MsolService -Credential $UserCredential


################################
# Steps to change Immutable ID #
################################
#    Get-MsolUser -UserPrincipalName MGiroir@hva.cc | select immutableID  
#    If the return result is empty, you can go ahead to run the hard-match:
#    Set-MsolUser -UserPrincipalName MGiroir@hva.cc -ImmutableId TWegcuQwWUKaUlV+Y9pRzA==  
#    (Highlight part please go with the actual immutable ID) 
#    If the return result is NOT empty, please run this command to set it as null first before matching; 
#    Set-MSolUSer -UserPrincipalName MGiroir@hva.cc -ImmutableID $null 
#    Set-MsolUser -UserPrincipalName MGiroir@hva.cc -ImmutableId TWegcuQwWUKaUlV+Y9pRzA== 


Function Convert-ImmutableID (
    [Parameter(Mandatory = $true)]
    $ImmutableID) { 
    ([GUID][System.Convert]::FromBase64String($ImmutableID)).Guid
}
Function Convert-ObjectGUID (
    [Parameter(Mandatory = $true)]
    $ObjectGUID) { 
    [system.convert]::ToBase64String(([GUID]$ObjectGUID).ToByteArray())
}
Convert-ImmutableID -ImmutableID 'h9RUd8MfBkKelc4BLxWG5Q=='
Convert-ObjectGUID -objectGUID '7754d487-1fc3-4206-9e95-ce012f1586e5'
