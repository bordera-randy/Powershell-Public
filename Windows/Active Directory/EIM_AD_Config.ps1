<#
.SYNOPSIS  
    Creates required service accounts and configures Active Directory for the Windows-side 
	of the IBM EIM Single Signon implementation.  
.DESCRIPTION  
    <Brief description of the script>
.INPUTS
	<Inputs if any, otherwise state None>
.OUTPUTS
		<Outputs if any, otherwise state None - example: Log file stored in C:\Windows>
.NOTES  
    File Name  : EIM_AD_Config.ps1  
    Author     : Scott Van Patten - SVanPatten@JackHenry.com  
    Requires   : PowerShell V4 or higher
.COMMENTARY
	1. Add error handling for each cmdlet - tell the user what went wrong, and how to correct if possible.
	2. Clarify inline comments 
	3. Consider error logging if failures can't be displayed to the user
	3. Consider using some housekeeping setup per the following template:
	http://9to5it.com/powershell-script-template/
	

#>


#Check if user is a member of Domain Admins group or nested groups
#$user = $env:USERNAME
#$group = "Domain Admins"
#$members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SamAccountName

#If ($members -contains $user) {
#Write-Host "$user exists in the group"
# }
 #Else {
#Write-Host "$user not exists in the group"
#}


#Check if PowerShell was run as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] “Administrator”))
{
Write-Warning “You must start PowerShell 'As Administrator' before running this script!`nClose this PowerShell window and restart 'As Administrator'`n`nTip: Right-click on PowerShell and click 'Run as Administrator'`n`nExiting script”
Read-Host -Prompt "Press Enter to exit"
Exit
}


#Check for ActiveDirectory Module. Exit script if not found.
Try
{
Import-Module ActiveDirectory -ErrorAction Stop
}
Catch
{
If($_.Exception.Message -eq "The specified module 'ActiveDirectory' was not loaded because no valid module file was found in any module directory." ){
Write-Host "ERROR: This script requires the Active Directory module for PowerShell. The module was not found." -ForegroundColor Red
Write-Host "`n`nTips:`n1. Run this script on a Domain Controller`n2. Use Server Manager Roles and Features to add feature 'Active Directory Module for Windows PowerShell'`n`nExiting script" -ForegroundColor Yellow
Exit
}
}
If(Get-Module -Name ActiveDirectory){
Write-Host "Active Directory module found and imported" -ForegroundColor Green
}
Else{
Write-Host "ERROR: Active Directory module was not imported successfully`n`nExiting script" -ForegroundColor Red
Exit
}


#Check for KTPASS. Exit script if not found.
$validateKtpass = "C:\Windows\System32\ktpass.exe"
$ktpassExists = Test-Path $validatektpass
If($ktpassExists -eq $true){
Write-Host "KTPASS found" -ForegroundColor green
}
Else {
Write-Warning "This script requires KTPASS.exe. KTPASS.exe was not found on this computer.`n`nTip: Run this script on a Windows Domain Controller"
Exit
}


#Determine Windows OS and Powershell version
$osCaption = (Get-WmiObject Win32_OperatingSystem).Caption
$osVersion = (Get-WmiObject Win32_OperatingSystem).Version
$psVersionMajor = $PSVersionTable.PSVersion.Major
$psVersionMinor = $PSVersionTable.PSVersion.Minor

If($osVersion -lt 6.2 -or $psVersionMajor -lt 4.0){
Write-Warning "`nFor best results, it is recommended you run this script on a Windows Domain Controller running Windows Server 2012 (or higher) and PowerShell v4.0 (or higher)"
Write-Host "`n`nCurrently installed:`n$osCaption`nPowerShell $psVersionMajor.$psVersionMinor`n`nPress Ctrl-c to exit"
Pause
}


#Query Active Directory for Domain name value and store in variable '$Domain' as a string
#$Domain = Get-ADDomain
#$Domain = $Domain.DNSRoot
$Domain = Get-ADDomainController
$Domain = $Domain.Domain


#Store 'Users' OU distinguished name in variable '$ouPath' as a string
$ouPath = Get-ADDomain -Identity $Domain
$ouPath = $ouPath.UsersContainer
#$ouPath = "OU=Users,OU=FrameworkServices,OU=Development Groups,DC=dev,DC=jha"

#Prompt user for FQDN of iSeries
$iSeriesFQDN = Read-Host -Prompt "`n`nEnter the full DNS name of the iSeries. Example: '12345678.MyDomain.com'"

#Assign account name for krbsvr400 service account. Account name is derived from iSeries FQDN
$AccountName_krbsvr400 = $iSeriesFQDN.Substring(0,$iSeriesFQDN.IndexOf("."))
$AccountName_krbsvr400 = $AccountName_krbsvr400 + "_krbsvr400"

#Assign User Principal Name for krbsvr400 service account "User@Domain"
$userPrincipal_krbsvr400 = $AccountName_krbsvr400 + "@$Domain"

#Assign account name for cifs service account. Account name is derived from iSeries FQDN
$AccountName_cifs = $iSeriesFQDN.Substring(0,$iSeriesFQDN.IndexOf("."))
$AccountName_cifs = $AccountName_cifs + "_cifs"

#Assign User Principal Name for cifs service account "User@Domain"
$userPrincipal_cifs = $AccountName_cifs + "@$Domain"

#Assign Service Principle Name for krbsvr400 service account
$SPN_krbsvr400 = "krbsvr400/$iSeriesFQDN"

#Assign Service Principle Name for cifs service account
$SPN_cifs = "cifs/$iSeriesFQDN"

#Check for duplicate accounts
Try{

if (Get-ADUser $AccountName_krbsvr400){
Write-Warning "Account '$AccountName_krbsvr400' already exists. This operation will REMOVE the existing account"
Remove-ADUser $AccountName_krbsvr400 -Confirm
}
if (Get-ADUser $AccountName_cifs){
Write-Warning "Account '$AccountName_cifs' already exists. This operation will REMOVE the existing account"
Remove-ADUser $AccountName_cifs -Confirm
}
}
Catch
{
}

#Prompt user for account password, compare passwords, prompt to re-enter if passwords do not match
do{

Try{

if (Get-ADUser $AccountName_krbsvr400){
Remove-ADUser $AccountName_krbsvr400 -Confirm:$false
}
if (Get-ADUser $AccountName_cifs){
Remove-ADUser $AccountName_cifs -Confirm:$false
}
}
catch
{
}
    do {
    $pwd1 = Read-Host -prompt "`n`nEnter account password" -AsSecureString
    $pwd2 = Read-Host -prompt "Confirm account password" -AsSecureString
    $pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
    $pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))

    if ($pwd1_text.compareTo($pwd2_text) -ne 0) {
    Write-Host "ERROR: Passwords do not match - Please re-enter the password" -ForegroundColor Red
    }
    }
    while ($pwd1_text.compareTo($pwd2_text) -ne 0)

$Error.Clear()

#Create krbsvr400 Service Account
Try
{
New-ADUser -Name $AccountName_krbsvr400 -DisplayName $AccountName_krbsvr400 -Path $ouPath `
-SamAccountName $AccountName_krbsvr400 `
-UserPrincipalName $userPrincipal_krbsvr400 -AccountPassword (ConvertTo-SecureString $pwd1_text -AsPlainText -Force) `
-PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true -ErrorAction Stop
}
Catch
{
$ErrorMessage = $_.Exception.Message

foreach ($ErrorMessage in $ErrorMessage){
if ($ErrorMessage -eq "The password does not meet the length, complexity, or history requirement of the domain."){
Write-Host "ERROR: The password does not meet the length, complexity, or history requirement of the domain.`nPlease enter another password" -ForegroundColor Red
}

ElseIf ($ErrorMessage -eq "Access is denied"){
Write-Host "ERROR: Access is denied." -ForegroundColor Red
Write-Host "`n`nTips:`n1. Try starting PowerShell 'As Administrator' before running this script.`n2. Ensure you have permissions to create user accounts in this OU (path): $ouPath`n`nExiting script" -ForegroundColor Yellow
Exit
}

Else {
Write-Host "`nERROR:"$_.Exception.InnerException -ForegroundColor Red
}
}
}
}
while ($Error.Count -ne 0)

#Create cifs Service Account
New-ADUser -Name $AccountName_cifs -DisplayName $AccountName_cifs -Path $ouPath `
-SamAccountName $AccountName_cifs `
-UserPrincipalName $userPrincipal_cifs -AccountPassword (ConvertTo-SecureString $pwd1_text -AsPlainText -Force) `
-PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true

Start-Sleep -Seconds 5

#Run KTPASS to map Service Principle Name to accounts and create keytab files
ktpass -mapuser $AccountName_krbsvr400 -princ $SPN_krbsvr400@$Domain -pass $pwd1_text -mapop set -crypto ALL -ptype KRB5_NT_PRINCIPAL
ktpass -mapuser $AccountName_cifs -princ $SPN_cifs@$Domain -pass $pwd1_text -mapop set -crypto ALL -ptype KRB5_NT_PRINCIPAL

#Set the Kerberos Encryption Type on accounts
Try
{
Set-ADUser $AccountName_krbsvr400 -KerberosEncryptionType AES128, AES256 -ErrorAction Stop
Set-ADUser $AccountName_cifs -KerberosEncryptionType AES128, AES256 -ErrorAction Stop
}
Catch
{
Write-Warning "`nThe script completed with errors. Please see details below:"
$ErrorMessage = $_.Exception.Message

foreach ($ErrorMessage in $ErrorMessage){
if ($ErrorMessage -eq "A parameter cannot be found that matches parameter name 'KerberosEncryptionType'."){
Write-Host "`nERROR: This script uses a parameter (KerberosEncryptionType) that is not supported by the version of PowerShell and/or Windows OS currently installed on this computer." -ForegroundColor Red
Write-Host "Tip: To set the Kerberos Encryption Type on the AD accounts, do ONE of the following:" `
"`n1. Re-run this script on a Windows Domain Controller running Windows Server 2012 (or higher) and PowerShell v4.0 (or higher)." `
"`n2. Use the Active Directory Users and Computers snap-in to manually set the Kerberos Encryption Type on the accounts." -ForegroundColor Yellow
}
}
}

#Trust the accounts for Delegation
Try
{
Set-ADUser $AccountName_krbsvr400 -TrustedForDelegation $true -ErrorAction Stop
Set-ADUser $AccountName_cifs -TrustedForDelegation $true -ErrorAction Stop
}
Catch
{
$ErrorMessage = $_.Exception.Message

foreach ($ErrorMessage in $ErrorMessage){
if ($ErrorMessage -eq "A required privilege is not held by the client"){
Write-Host "`nERROR: You do not have the rights required to enable the new accounts to be trusted for delegation. You must be a member of the Domain Admins Group to complete this task.`n" -ForegroundColor Red
}
}
}
Finally
{
If($Error.Count -eq 0){
Write-Host "`nThe script completed successfully" -ForegroundColor Green
}
}

#Generate text file for Outlink Support
"*****************************************************************************************************************",`
"NOTICE: The contents of this file is required to set up EIM on iSeries. Please send this file to Outlink Support.",`
"*****************************************************************************************************************","`n","`n",`
"[KRBSVR400]",`
"OU Path: $ouPath",`
"Account name: $AccountName_krbsvr400",`
"SPN: $SPN_krbsvr400@$Domain",`
"PW: $pwd1_text","`n","`n",`
"[CIFS]",`
"OU Path: $ouPath",`
"Account name: $AccountName_cifs",`
"SPN: $SPN_cifs@$Domain",`
"PW: $pwd1_text" |`
Out-File .\$Domain.txt
Notepad .\$Domain.txt


#Prompt user to close PowerShell console window
Read-Host -Prompt "Press Enter to exit"