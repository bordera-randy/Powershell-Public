
#   The instructions for manual Cylance removal:
#   Make sure to back up the registry externally before attempting this change.

#   1: Open Regedit and navigate to HKEY_LOCAL_MACHINE\SOFTWARE\Cylance\Desktop folder. 
#   Right click the Desktop folder along the left pane and click Permissions.

#   Click Add and add a domain Administrator with Full control.
#   On the Permissions screen click advanced.
#   Select the admin you added to the folder and at the bottom check the box for replacing permissions and click the enable inheritance 
 
#   Make sure to save and apply the changes

#   2: Then you will need to delete the registry key called "LastStateRestorePoint"
#   3: Then add a DWORD32 to HKEY_LOCAL_MACHINE\SOFTWARE\Cylance\Desktop called "SelfProtectionLevel" and set the value to 1
#   4: Then reboot the device. 

#   Once the device is back up, you should be able to stop the Cylance service manually and proceed with the uninstall.

#   5: Close all applications on the computer(It will prompt you to do so during uninstall process if you do not do this ahead of time)
#   6: Open appwiz.cpl and remove Cylance Protect and Cylance Optics if either are present. (Alternatively, open the command prompt as admin and run the following: msiexec /x {2E64FC5C-9286-4A31-916B-0D8AE4B22954})


$acl = Get-Acl HKLM:\SOFTWARE\Cylance\Desktop
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ("Domain\administrator","FullControl","Allow")
$acl.SetAccessRule($rule)
$acl |Set-Acl -Path HKLM:\SOFTWARE\Cylance\Desktop

reg delete  Registry_key_path /v Registry_value_name

REG DELETE HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer /v CleanShutdown

REG ADD HKLM\SOFTWARE\Cylance\Desktop /v SelfProtectionLevel /t REG_DWORD /d 1


