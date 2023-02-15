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
