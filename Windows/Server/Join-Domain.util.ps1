


$domain     = 'poc.dct.local'
$username   = "$domain\randyb"
$password   = '798p%oh%yiA7'

<#          #>
$securepass = $password | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $securepass
Add-Computer -DomainName $domain -Credential $cred -Restart -Force



