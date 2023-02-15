

 
<#     

.NOTES 
#=============================================
# Script      : RemotePS-E16.ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey.Dedeal  
# Date        : 02/06/2019 11:15:03  
# Org         : ETC Solutions 
# File Name   : RemotePS-E16.ps1 
# Comments    : Connect random E2016 server via remote PS
# Assumptions : 
#==============================================

SYNOPSIS           : RemotePS-E16.ps1 
DESCRIPTION        :
Acknowledgements   : Open license, fell free to use it as you wish
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\RemotePS-E16.ps1 

  MAP:
  -----------
  (1)_.Preparing array
  (2)_.Selectingg Random Exchange 2016 Server 
  (3)_.Connecting to remote session
  (4)_.Importing session
  (5)_.Executing RemotePS-E16 , connecting Exchange Server via PS

#> 


Function RemotePS-E16 {
 
    #(1)_.Preparing array 
 $array=@(
  
           # E2016 New
            "MAIL101","MAIL102","MAIL103","MAIL104"
            "MAIL105","MAIL106","MAIL107","MAIL108"
            "MAIL109","MAIL110","MAIL111","MAIL112"
            "MAIL113","MAIL114","MAIL115","MAIL116"
         )

    #(2)_.Selecting Random Exchange 2016 Server        
    $RemoteServer = $array[(Get-Random -Maximum ([array]$array).count)]
    
      #(3)_.Connecting to remote session
        $session = New-PSSession -ConfigurationName Microsoft.Exchange `
        -ConnectionUri http://$RemoteServer/PowerShell/ `
        -Authentication Kerberos 
      
      #(4)_.Importing session
         Import-PSSession $session -AllowClobber
} 

#(5)_.Executing RemotePS-E16 , connecting Exchange Server via PS
write-host $null
write-host $null
write-host "+++++++++++++++++++++++++++++++++++"
Write-Warning "()_.Connecting Remote PowerShell."
RemotePS-E16
Clear-Host