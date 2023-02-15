<##################################################################################################
    Name:           Enable-IIS-Audit-Logging.ps1    
    Created By:     Randy Bordeaux (randy@randybordeaux.com)
    Date Created:   7/7/2021
    Date Modified: 
    Description: 
        This script will configure audit logging for IIS configuration changes
        and file level auditing.          

    Documentation:
     
    https://www.powershellgallery.com/packages/NTFSSecurity/4.2.6

##################################################################################################>

<# Error handling #>
$error.Clear()
$ErrorActionPreference = 'silentlycontinue'

<# Required Modules #> 
Install-Module NtfsSecurity

<# Variables #>
$path = 'C:\Windows\System32\inetsrv\config'

<# Add file level logging for IIS Config files #>
Add-NTFSAudit -Path $path -AccessRights CreateFiles, DeleteSubdirectoriesAndFiles, Delete -Account Everyone -AuditFlags Success -InheritanceFlags ContainerInherit,ObjectInherit -PropagationFlags None
Get-NTFSAudit -Path $path | fl

<# Enable IIS-Configuration Operational logs #>
wevtutil sl Microsoft-IIS-Configuration/Operational /e:true

<# Create Error Log #>
$error | out-file c:\temp\audit-logging-config.log
