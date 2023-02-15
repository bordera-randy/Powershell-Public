
##########################################################################################################################
#     Name: Allow modern authentication - skype for business
#     Date Created: 9/1/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will connect to the Office 365 SFB and allow modern auth
#
##########################################################################################################################


#############
# Variables #
#############

$sfboSession = New-CsOnlineSession 

#############
# Main      #
#############

#connect to Skype for Business
Import-PSSession $sfboSession

#enable modern authentication 
Set-CsOAuthConfiguration -ClientAdalAuthOverride Allowed

#verify modern authentication is set to allow 
Get-CsOAuthConfiguration | select ClientAdalAuthOverride