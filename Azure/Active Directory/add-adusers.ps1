

$csvfile    = "c:\temp\newusers.csv"
$domain     = "VALUEHERE"
$group1     = "SECURITYGROUPNAME"



# Download Template
$source = 'https://www.alitajran.com/wp-content/uploads/spreadsheets/NewUsersSent.csv'
$destination = $csvfile
Invoke-RestMethod -Uri $source -OutFile $destination
Write-Host -ForegroundColor Yellow "Check the c:\temp folder for a file called newusers.csv. This file will need to be populated with the user details."


write-host -ForegroundColor Red "Please save the file in the same location. When ready press enter"
Pause

# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv $csvfile -Delimiter ";"

# Define UPN
$UPN = $domain

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $email = $User.email
    $streetaddress = $User.streetaddress
    $city = $User.city
    $zipcode = $User.zipcode
    $state = $User.state
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        # If user is created, show message.
        Write-Host "The user account $username is created." -ForegroundColor Cyan
        write-Host -ForegroundColor Yellow "Adding user to distribution groups."
        Add-ADGroupMember $group1 -Members $username 
    }
}

Read-Host -Prompt "Press Enter to exit"


