<########################################################################################################################################################
    Name: Upload-Secrets.Util.ps1
    Author: Randy Bordeaux 
    Date Created: 12/19/2022
    Date Modified:
    
    Description: 
        Upload secrets into Azure key vault 
        Create a text file with the secretname and value
        there should be 1 secret per line
        save the file as a .txt
        deliminator ~
        
        Example secretname~secretvaule

########################################################################################################################################################>
$error.clear() #clear error variable 

######################################################################
####### Change variable values for the key vault and file path #######
######################################################################

<# Variables #>
$kvname   = 'VAULTNAME'
$kvuploadfile = "FULLPATHTOFILE"
######################################################################


# Connect to Azure
Connect-AzAccount 

$kv = Get-AzKeyVault | Where-Object vaultname -like $($kvname)
$secretNames = Get-Content -Path $kvuploadfile
write-host -ForegroundColor Magenta "Updating secrets in $kv"
<# Load Secrets #>
    foreach ($secret in $secretNames) {
        $lines = $secret.Split('~')
        $secureValue = ConvertTo-SecureString -String $lines[1] -AsPlainText -Force
        write-host -ForegroundColor Yellow "Updating $($lines[0])"
        Set-AzKeyVaultSecret -VaultName $kv.vaultname -Name $lines[0] -SecretValue $secureValue -ContentType 'txt'
    }
write-host -ForegroundColor green "Key Vault update Complete"

