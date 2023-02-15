#************************************************
# MSOLTenantDetails.ps1
# Version 1.0
# Date: 1-30-2013
# Author: Tspring
# Description: Script for taking an O365 user credential and
# determining the verified and unverified domains, what SKU is being
# used and what licensing the user has and returning that data.
#************************************************

cls

Trap [Exception]
		{# Handle exception and then continue with function and script.
		 $Script:ExceptionMessage = $_
		 Write-host "[info]:An exception occurred." -shortformat
		 Write-host "[info]: Exception.Message $ExceptionMessage."
		 Write-host $_
		 $Error.Clear()
		 continue
		}
	
#"Master" PSObject for returned data.
$MSOLTenantDetails = New-Object PSObject

$Creds = Get-Credential
Import-Module MSOnline
Connect-MsolService -Credential $Creds

#get all mso domains
$Domains = Get-MsolDomain
$DomCount = $Domains.Count

$TentantDetails = New-Object PSObject

#Members are User Name, User UPN, IsTenantAdmin, and each domain will have properties of 
# Authentication, Capabilities, IsDefault, IsInitial, Name, RootDomain and Status. 
#Add password policy setting info
#####################################
#####################################
$UserInfo = Get-MsolUser -UserPrincipalName $Creds.UserName
$MSOLAccountSKU = Get-MsolAccountSku
$TenantId = $MSOLAccountSKU.AccountObjectId
$AccountName = $MSOLAccountSKU.AccountName


#Determine user role memberships.
####################################
$TenantId = $MSOLAccountSKU.AccountObjectId
$UserName = $Creds.UserName
$IsPartnerTier1Admin = $false
$IsTenantAdmin = $false
$IsHelpDeskMember = $false
$IsDirectoryReader = $false
$IsBillingMember = $false
$IsPartnerTier2Member = $false
$IsServiceSupportMember = $false
$IsUserAccountMember = $false

#Get roles and role guids, then get role members.
$MSOLRole = Get-MsolRole -ErrorAction SilentlyContinue

if ($MSOLRole -ne $null)
	{$PartnerTier1GUID = $MSOLRole[0].ObjectId.Guid
     $AdminRoleGUID = $MSOLRole[1].ObjectId.Guid
     $HelpDeskGUID = $MSOLRole[2].ObjectId.Guid
	 $DirectoryReaderGUID = $MSOLRole[3].ObjectId.Guid
	 $BillingAdminGUID = $MSOLRole[4].ObjectId.Guid
	 $PartnerTier2GUID = $MSOLRole[5].ObjectId.Guid
	 $ServiceSupportAdminGUID = $MSOLRole[6].ObjectId.Guid
	 $UserAccountAdminGUID = $MSOLRole[7].ObjectId.Guid
	 $PartnerTier1RoleMembers = Get-MsolRoleMember -RoleObjectId $PartnerTier1GUID
	 $AdminRoleMembers = Get-MsolRoleMember -RoleObjectId $AdminRoleGUID
	 $HelpDeskRoleMembers = Get-MsolRoleMember -RoleObjectId $HelpDeskGUID
	 $DirectoryReaderRoleMembers = Get-MsolRoleMember -RoleObjectId $DirectoryReaderGUID
	 $BillingRoleMembers = Get-MsolRoleMember -RoleObjectId $BillingAdminGUID
	 $PartnerTier2RoleMembers = Get-MsolRoleMember -RoleObjectId $PartnerTier2GUID
	 $ServiceSupportRoleMembers = Get-MsolRoleMember -RoleObjectId $ServiceSupportAdminGUID
	 $UserAccountRoleMembers = Get-MsolRoleMember -RoleObjectId $UserAccountAdminGUID
     #Compare member lists to see if the current user is a member. 
	ForEach ($PartnerTier1RoleMember in $PartnerTier1RoleMembers)
		{ if ($PartnerTier1RoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsPartnerTier1Admin = $True}
		}
	ForEach ($AdminRoleMember in $AdminroleMembers)
		{ if ($AdminRoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsTenantAdmin = $True}
		}
	ForEach ($HelpDeskRoleMember in $HelpDeskRoleMembers)
		{ if ($HelpDeskRoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsHelpDeskMember = $True}
		}
	ForEach ($DirectoryReaderRoleMember in $DirectoryReaderRoleMembers)
		{ if ($DirectoryReaderRoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsDirectoryReader = $True}
		}
	ForEach ($BillingRoleMember in $BillingRoleMembers)
		{ if ($BillingRoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsBillingMember = $True}
		}
	ForEach ($PartnerTier2RoleMember in $PartnerTier2RoleMembers)
		{ if ($PartnerTier2RoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsPartnerTier2Member = $True}
		}
	ForEach ($ServiceSupportRoleMember in $ServiceSupportRoleMembers)
		{ if ($ServiceSupportRoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsServiceSupportMember = $True}
		}
	ForEach ($UserAccountRoleMember in $UserAccountRoleMembers)
		{ if ($UserAccountRoleMember.EmailAddress -match $UserInfo.UserPrincipalName)
			{ $IsUserAccountMember = $True}
		}
	}
	
$LicensePack = $UserInfo.Licenses[0].AccountSkuId

add-member -inputobject $TentantDetails -membertype noteproperty -name "DisplayName" -value $UserInfo.DisplayName
add-member -inputobject $TentantDetails -membertype noteproperty -name "UserPrincipalName" -value $UserInfo.UserPrincipalName
add-member -inputobject $TentantDetails -membertype noteproperty -name "LastDirSyncTime" -value $UserInfo.LastDirSyncTime
add-member -inputobject $TentantDetails -membertype noteproperty -name "ImmutableID" -value $UserInfo.ImmutableId
add-member -inputobject $TentantDetails -membertype noteproperty -name "Errors" -value $UserInfo.Errors
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsBlackBerryUser" -value $UserInfo.IsBlackberryUser
add-member -inputobject $TentantDetails -membertype noteproperty -name "LiveID" -value $UserInfo.LiveId
add-member -inputobject $TentantDetails -membertype noteproperty -name "ObjectID" -value $UserInfo.ObjectId
add-member -inputobject $TentantDetails -membertype noteproperty -name "ValidationStatus" -value $UserInfo.ValidationStatus
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsLicensed" -value $UserInfo.IsLicensed
add-member -inputobject $TentantDetails -membertype noteproperty -name "LicenseReconciliationNeeded" -value $UserInfo.LicenseReconciliationNeeded
add-member -inputobject $TentantDetails -membertype noteproperty -name "LicensePack" -value $UserInfo.Licenses[0].AccountSkuId
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsPartnerTier1Admin" -value $IsPartnerTier1Admin
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsTenantAdmin" -value $IsTenantAdmin
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsHelpDeskMember" -value $IsHelpDeskMember
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsDirectoryReader" -value $IsDirectoryReader
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsBillingMember" -value $IsBillingMember
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsPartnerTier2Member" -value $IsPartnerTier2Member
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsServiceSupportMemer" -value $IsServiceSupportMember
add-member -inputobject $TentantDetails -membertype noteproperty -name "IsUserAccountMember" -value $IsUserAccountMember
add-member -inputobject $TentantDetails -membertype noteproperty -name "DomainCount" -value $DomCount


#Add user details to the "master" PSObject.
Add-Member -InputObject $MSOLTenantDetails -MemberType NoteProperty -Name "TenantDetails" -Value $TentantDetails

#Email addresses for the user. Since they are multi valued and we don't know how 
#many there will be we'll place them into "child" PSObjects as well. One fpr alternate
#email addresses and one for ProxyEmail addresses.
########################################
########################################
$UserAlternateEmails = New-Object PSObject
$AlternateEmailAddresses = $UserInfo.AlternateEmailAddresses
ForEach ($AlternateEmailAddress in $AlternateEmailAddresses)
	{
	 add-member -inputobject $UserAlternateEmails -membertype noteproperty -name $AlternateEmailAddress -value $AlternateEmailAddress
	}

$UserProxyAddresses = New-Object PSObject
$ProxyAddresses = $UserInfo.ProxyAddresses
ForEach ($ProxyAddress in $ProxyAddresses)
	{
	 add-member -inputobject $UserProxyAddresses -membertype noteproperty -name $ProxyAddress -value $ProxyAddress
	}

#Add email addresses to the "master" PSObject.
Add-Member -InputObject $MSOLTenantDetails -MemberType NoteProperty -Name "AlternateEmailAddresses" -Value $UserAlternateEmails
Add-Member -InputObject $MSOLTenantDetails -MemberType NoteProperty -Name "ProxyAddresses" -Value $ProxyAddresses

#Licensing: add each License by ServiceStatus which the License pack allows for and their status.
########################################
########################################
$Licenses = $UserInfo.Licenses[0].ServiceStatus
if ($Licenses -ne $null)
	{$LicenseCounter = 0
	 ForEach ($License in $Licenses)
		{
	 	 $LicenseObject = New-Object PSObject
	 	 add-member -inputobject $LicenseObject -membertype noteproperty -name "LicenseServicePlanName" -value  $License.ServicePlan.ServiceName
	 	 add-member -inputobject $LicenseObject -membertype noteproperty -name  "LicenseServiceProvStatus" -value $License.ProvisioningStatus
	 	 add-member -inputobject $LicenseObject -membertype noteproperty -name "LicenseServicePlanId" -value $License.ServicePlan.ServicePlanID
	 	 $LicenseCounter++
			switch ($License.ServicePlan.ServicePlanId)
				{
				'bea4c11e-220a-4e6d-8eb8-8ea15d019f90'
					{$LicenseNameString = "RMS_S_ENTERPRISE (Rights Management Service)"}
				'43de0ff5-c92c-492b-9116-175376d08c38'
					{$LicenseNameString =  "OFFICESUBSCRIPTION (Office Professional Plus)"}
				'0feaeb32-d00e-4d66-bd5a-43b5b83db82c'
					{$LicenseNameString =  "MCOSTANDARD (Lync Online)"}
				'e95bec33-7c88-4a70-8e19-b10bd9d0c014'
					{$LicenseNameString =  "SHAREPOINTWAC (Microsoft Office Web Apps)"}
				'5dbe027f-2339-4123-9542-606e4d348a72'
					{$LicenseNameString =  "SHAREPOINTENTERPRISE (SharePoint Online)"}
				'efb87545-963c-4e0d-99df-69c6916d9eb0'
					{$LicenseNameString =  "EXCHANGE_S_ENTERPRISE (Exchange Online)"}
				}	
		
	 	 add-member -inputobject $MSOLTenantDetails -membertype noteproperty -name $LicenseNameString -value $LicenseObject
		$LicenseNameString = $null
		}
	}

#Domain Info
########################################
########################################
[Array]$Domains = Get-MsolDomain
ForEach ($Domain in $Domains)
	{
	 $DomainObject = New-Object PSObject
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "Domain Name" -value $Domain.Name
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "DomainAuthentication" -value $Domain.Authentication
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "DomainCapabilities" -value $Domain.Capabilities
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "DomainIsDefault" -value $Domain.IsDefault 
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "DomainIsInitial" -value $Domain.IsInitial 
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "DomainRootDomain" -value $Domain.RootDomain
	 add-member -inputobject $DomainObject -membertype noteproperty -name  "DomainStatus" -value $Domain.Status
	
	 #Add this PSObject to the "master" one.
	 add-member -inputobject $MSOLTenantDetails -membertype noteproperty -name  $Domain.Name -value $DomainObject
	 $DomainObject = $null
	 }

	$MSOLTenantDetails | FL


