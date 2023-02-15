 $UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

# To soft delete items 
#New-ComplianceSearchAction -SearchName "Remove Phishing Message" -Purge -PurgeType SoftDelete

# To hard-delete the items returned by the "Remove Phishing Message" content search, you would run this command:
#New-ComplianceSearchAction -SearchName "Remove Phishing Message" -Purge -PurgeType HardDelete