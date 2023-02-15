
Install-Module AzureADPreview -AllowClobber
Import-Module AzureADPreview


Connect-AzureAD

Set-AzContext 'VALUEHERE'


Get-AzureADMSTrustFrameworkPolicy

# Download and send policy output to a file
Get-AzureADMSTrustFrameworkPolicy -Id B2C_1A_signup_signin -OutputFilePath C:\RPPolicy.xml



