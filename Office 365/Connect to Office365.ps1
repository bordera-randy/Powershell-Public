
##########################################################################################################################
#     Name: Connect to office 365
#     Date Created: 8/20/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will connect to the Office 365 
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
