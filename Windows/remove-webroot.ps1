<#############################################################################################
    Name: remove-webroot
    Author: Randy Bordeaux
    Date Created: 7/6/2021
    Date Modified:
    
    Description: 
        This will silently remove the webroot Anti-virus client    


    Requirements: 
        Powershell 6.X.X or later
        NET Framework 4.7.2 or later
        Administrator privledges 
        
        
    Documentation: 
        
        https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1
        https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1
        
                
#############################################################################################>

<# Variables #>
$ErrorActionPreference = 'silentlycontinue'


mkdir c:\temp 
Start-Transcript c:\temp\webroot_uninstall.log
<# Download files #>
Invoke-WebRequest https://anywhere.webrootcloudav.com/zerol/wsasme.msi -OutFile C:\temp\wsasme.msi

<# Uninstall  #>
msiexec /uninstall c:\temp\wsasme.msi /qn
Stop-Transcript
​
### End of File ### 
