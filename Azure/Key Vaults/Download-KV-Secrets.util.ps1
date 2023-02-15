<#
.SYNOPSIS
	Download secrets from a key vault to a text file

.DESCRIPTION
    Name: Download-KV-Secrets.util.ps1
    Author: Randy Bordeaux 
    Date Created: 06/06/2022
    Date Modified:
    
    Description: 
        Download keyvault secrets to a text file. The deliminator is ~
        (Date Format MMddYYY).
        File Location: c:\az\keyvault
        
        Example: vaultname-06062022.txt
        
    Requirements: 
        Modules: 
            AZ 
        Key Vault Access policy 
        Key Vault Network Access

    Documentation: 

#>



import-Module -Name Az
Connect-AzAccount

$tenandid   = 'VALUEHERE'
$sub        = 'VALUEHERE'
$kv         = "VALUEHERE"
$path       = "c:\az\keyvault"

Set-AzContext $sub -Tenant $tenandid
$date = Get-Date -Format "MMddyyyy"
$kvdownloadfile = "$path\$kv-$date.txt"
$test = test-path $path
IF (!(test-path $path)) {
    mkdir $path
}
try {

    $secretNames = (Get-AzKeyVaultSecret -VaultName $kv).Name
    Write-Host $secretNames 
    foreach($secret in $secretNames)
    {
    Add-Content -Path $kvdownloadfile -Value ($secret + '~' + [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((Get-AzKeyVaultSecret -VaultName $kv -Name $secret).SecretValue)))
    }
    cls
    Write-Host -ForegroundColor Magenta "Key Vault $kv has been downloaded, Please check $kvdownloadfile"    
}
catch {
    Write-Host -ForegroundColor Red "UNABLE TO DOWNLOAD KEY VAULT"    
}

$secretNames = (Get-AzKeyVaultSecret -VaultName $kv).Name
Write-Host $secretNames 
foreach($secret in $secretNames)
{
Add-Content -Path $kvdownloadfile -Value ($secret + '~' + [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((Get-AzKeyVaultSecret -VaultName $kv -Name $secret).SecretValue)))
}




