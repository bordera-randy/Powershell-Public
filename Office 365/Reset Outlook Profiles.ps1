###########################################################################################################################
#     Name: Reset Outlook Profiles
#     Description: This script will delete the registry keys for the outlook profiles, create 
#     a new profile named outlook, and set it as default
#
#     Author: Randy Bordeaux
#     Date Created: 6/21/2020
#     Date Modified
#
###########################################################################################################################
#outlook 2013
remove-item -path "REGISTRY::HKEY_USERS\*\Software\Microsoft\Office\15.0\Outlook\Profiles\outlook" -recurse
new-item -path "REGISTRY::HKEY_USERS\*\Software\Microsoft\Office\15.0\Outlook\Profiles\" -name outlook -force
Set-ItemProperty -Path "REGISTRY::HKEY_USERS\*\Software\Microsoft\Office\15.0\Outlook" -Name "DefaultProfile" -Value outlook

#outlook 2016
remove-item -path "REGISTRY::HKEY_USERS\*\Software\Microsoft\Office\16.0\Outlook\Profiles\outlook" -recurse
new-item -path "REGISTRY::HKEY_USERS\*\Software\Microsoft\Office\16.0\Outlook\Profiles\" -name outlook -force
Set-ItemProperty -Path "REGISTRY::HKEY_USERS\*\Software\Microsoft\Office\16.0\Outlook" -Name "DefaultProfile" -Value outlook
