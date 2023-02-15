######################################################
#     
#     Description:    This script will create the active directory structure
#     Author:         Randy Bordeaux
#     Date Created:   6/9/2020
#
######################################################

# import modules 
import-module activedirectory

 
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Creating Active Directory Structure..."

# Create OU's
New-ADOrganizationalUnit -Name "BISD" -Path "DC=BISD,DC=NET"
    New-ADOrganizationalUnit -Name "Users" -Path "OU=BISD,DC=BISD,DC=NET"
        New-ADOrganizationalUnit -Name "Staff" -Path "OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Admin" -Path "OU=Staff,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Teachers" -Path "OU=Staff,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Principals" -Path "OU=Staff,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Secretaries" -Path "OU=Staff,OU=Users,OU=BISD,DC=BISD,DC=NET"
        New-ADOrganizationalUnit -Name "Students" -Path "OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 6" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 7" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 8" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 9" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 10" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 11" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Grade 12" -Path "OU=Students,OU=Users,OU=BISD,DC=BISD,DC=NET"

    New-ADOrganizationalUnit -Name "Computers" -Path "OU=BISD,DC=BISD,DC=NET"
        
        New-ADOrganizationalUnit -Name "Labs" -Path "OU=Computers,OU=BISD,DC=BISD,DC=NET"
        
            New-ADOrganizationalUnit -Name "High School" -Path "OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Art" -Path "OU=High School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Desktop Publishing" -Path "OU=High School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Science" -Path "OU=High School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Video Tech" -Path "OU=High School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Virtual School" -Path "OU=High School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
        
            New-ADOrganizationalUnit -Name "Middle School" -Path "OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Art" -Path "OU=Middle School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Desktop Publishing" -Path "OU=Middle School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Science" -Path "OU=Middle School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Video Tech" -Path "OU=Middle School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Virtual School" -Path "OU=Middle School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
        
            New-ADOrganizationalUnit -Name "Elementary School" -Path "OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Art" -Path "OU=Elementary School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Desktop Publishing" -Path "OU=Elementary School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Science" -Path "OU=Elementary School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Video Tech" -Path "OU=Elementary School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
                New-ADOrganizationalUnit -Name "Virtual School" -Path "OU=Elementary School,OU=Labs,OU=Computers,OU=BISD,DC=BISD,DC=NET"
        
        New-ADOrganizationalUnit -Name "Servers" -Path "OU=Computers,OU=BISD,DC=BISD,DC=NET"
        New-ADOrganizationalUnit -Name "Classrooms" -Path "OU=Computers,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "High School" -Path "OU=Classrooms,OU=Computers,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Middle School" -Path "OU=Classrooms,OU=Computers,OU=BISD,DC=BISD,DC=NET"
            New-ADOrganizationalUnit -Name "Elementary School" -Path "OU=Classrooms,OU=Computers,OU=BISD,DC=BISD,DC=NET"

        New-ADOrganizationalUnit -Name "Cafeteria" -Path "OU=Computers,OU=BISD,DC=BISD,DC=NET"

        New-ADOrganizationalUnit -Name "Library" -Path "OU=Computers,OU=BISD,DC=BISD,DC=NET"



write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Active Directory Structure has been completed"
write-host -ForegroundColor DarkRed -BackgroundColor Yellow ""
write-host -ForegroundColor DarkRed -BackgroundColor Yellow ""
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Please import Users"
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Script has completed"

  
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv C:\AD_Info\bulk_users1.csv

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
	$OU 		= $User.ou #This field refers to the OU the user account is to be created in
    $email      = $User.email
    $streetaddress = $User.streetaddress
    $city       = $User.city
    $zipcode    = $User.zipcode
    $state      = $User.state
    $country    = $User.country
    $telephone  = $User.telephone
    $jobtitle   = $User.jobtitle
    $company    = $User.company
    $department = $User.department
    $Password = $User.Password


	#Check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@winadpro.com" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True
            
	}
}


###################
# set new password, enable accounts, set userprincipalname

Get-ADUser -Filter * -SearchScope Subtree -SearchBase "OU=Atlanta,OU=MacPhersonsArt,DC=macphersons,DC=net" | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Winteriscoming2020!" -Force)
Get-ADUser -Filter * -SearchScope Subtree -SearchBase "OU=Atlanta,OU=MacPhersonsArt,DC=macphersons,DC=net" | set-aduser -Enabled:$False
Get-ADUser -Filter * -SearchScope Subtree -SearchBase "OU=Atlanta,OU=MacPhersonsArt,DC=macphersons,DC=net" | foreach { Set-ADUser $_ -UserPrincipalName (“{0}@{1}” -f $_.name,”macphersons.net”)}


