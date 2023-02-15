##########################################################################################################################
#     Name: Email Migration New Outlook Profile
#     Date Created: 7/27/2020
#     Date Modified: 
#     Author:  Randy Bordeaux
#     Description: This script will create a new outlook profile and set it as the default profile 
#
##########################################################################################################################

#Remove-Item -Path 'HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles\O365'
#Remove-Item -Path 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\O365'
#Remove-Item -Path 'HKCU\Software\Microsoft\Office\15.0\Outlook\Profiles\O365'

#########################################
#              Create O365 Profile
#########################################

write-host -ForegroundColor yellow -BackgroundColor Red "Creating new Profile...."

#Outlook 2010
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\O365"
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles" /v DefaultProfile /t REG_SZ /d "O365" /F
reg add "HKCU\Software\Microsoft\Exchange\Client\Options" /v PickLogonProfile /t REG_DWORD /d "0" /f

#Outlook 2013
reg add HKCU\Software\Microsoft\Office\15.0\Outlook\Profiles\O365
reg add "HKCU\Software\Microsoft\Office\15.0\Outlook" /v DefaultProfile /t REG_SZ /d "O365" /F

#Outlook 2016 and 2019
reg add HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles\O365
reg add "HKCU\Software\Microsoft\Office\16.0\Outlook" /v DefaultProfile /t REG_SZ /d "O365" /F

#########################################
#              Script Complete
#########################################

write-host -ForegroundColor yellow -BackgroundColor Red "O365 Profile has been created..."

#########################################
#              Script Complete
#########################################


