######################################################
#     
#     Description:    This script will gather data on the active directory environment
#     Author:         Randy Bordeaux
#     Date Created:   6/9/2020
#
######################################################
Start-Transcript c:\ad_info\transcript.txt

# import modules 
import-module activedirectory
#### DNS Records 
$Zones = @(Get-DnsServerZone)
ForEach ($Zone in $Zones) {
	Write-Host "`n$($Zone.ZoneName)" -ForegroundColor "Green"
	$Zone | Get-DnsServerResourceRecord
} 

write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Gathering user information..." 
write-host -ForegroundColor DarkRed -BackgroundColor Yellow ""
# Export users 
#get-aduser -filter * -Properties * | export-csv -NoTypeInformation c:\AD_Info\adusers.csv
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "User information has been exported to a .csv file"
write-host -ForegroundColor DarkRed -BackgroundColor Yellow ""
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Starting Group membership retrieval... "
# Get Groups and group memberships

# Get year and month for csv export file
$DateTime = Get-Date -f "yyyy-MM"

# Set CSV file name
#$CSVFile = "C:\AD_Info\AD_Groups"+$DateTime+".csv"

# Create emy array for CSV data
$CSVOutput = @()

# Get all AD groups in the domain
$ADGroups = Get-ADGroup -Filter *

# Set progress bar variables
$i=0
$tot = $ADGroups.count

foreach ($ADGroup in $ADGroups) {
	# Set up progress bar
	$i++
	$status = "{0:N0}" -f ($i / $tot * 100)
	Write-Progress -Activity "Exporting AD Groups" -status "Processing Group $i of $tot : $status% Completed" -PercentComplete ($i / $tot * 100)

	# Ensure Members variable is empty
	$Members = ""

	# Get group members which are also groups and add to string
	$MembersArr = Get-ADGroup -filter {Name -eq $ADGroup.Name} | Get-ADGroupMember | select Name
	if ($MembersArr) {
		foreach ($Member in $MembersArr) {
			$Members = $Members + "," + $Member.Name
		}
		$Members = $Members.Substring(1,($Members.Length) -1)
	}

	# Set up hash table and add values
	$HashTab = $NULL
	$HashTab = [ordered]@{
		"Name" = $ADGroup.Name
		"Category" = $ADGroup.GroupCategory
		"Scope" = $ADGroup.GroupScope
		"Members" = $Members
	}

	# Add hash table to CSV data array
	$CSVOutput += New-Object PSObject -Property $HashTab
}

# Export to CSV files
$CSVOutput | Sort-Object Name 
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Group membership retrieval completed"
write-host -ForegroundColor DarkRed -BackgroundColor Yellow " Gathering Domain Info..."
get-addomain 
Import-Module grouppolicy
$date = get-date -format M.d.yyyy-HH.mm.ss
New-Item -Path c:\support\GPBackup\$date -ItemType directory
sleep 10
get-gporeport -All -ReportType Html -Path c:\temp\GPBackup.html


##########################################################################################################

########
## Main
########

#Create a variable for the domain DN
$DomainDn = (Get-ADDomain -Identity $Domain).DistinguishedName

#Create a variable for the domain DN
$DomainNetbios = (Get-ADDomain -Identity $Domain).NetBIOSName

#Specify a XML report variable
$CsvReport = "c:\ad_info\$(Get-Date -Format yyMMddHHmmss)_$($DomainNetbios)_OU_Dump.xml" 

#Create an array to  contain our custom PS objects
$TotalOus = @()

#Create user counter
$i = 0

#Get-ADOrganizationalUnit dumps the OU structure in a logical order (thank you cmdlet author!) 
$Ous = Get-ADOrganizationalUnit -Filter * -SearchScope Subtree -Server $Domain -Properties ParentGuid -ErrorAction SilentlyContinue | 
       Select Name,DistinguishedName,ParentGuid 

#Check that we have some output
if ($Ous) {

    #Loop through each OU, create a custom object and add to $TotalOUs
    foreach ($Ou in $Ous){

        #Convert the parentGUID attribute (stored as a byte array) into a proper-job GUID
        $ParentGuid = ([GUID]$Ou.ParentGuid).Guid

        #Attempt to retrieve the object referenced by the parent GUID
        $ParentObject = Get-ADObject -Identity $ParentGuid -Server $Domain -ErrorAction SilentlyContinue

        #Check that we've retrieved the parent
        if ($ParentObject) {

            #Create a custom PS object
            $OuInfo = [PSCustomObject]@{

                Name = $Ou.Name
                DistinguishedName = $Ou.DistinguishedName
                ParentDn = $ParentObject.DistinguishedName
                DomainDn = $DomainDn
        
             }   #End of $Properties...


            #Add the object to our array
            $TotalOus += $OuInfo

            #Spin up a progress bar for each filter processed
            Write-Progress -Activity "Finding OUs in $DomainDn" -Status "Processed: $i" -PercentComplete -1

            #Increment the filter counter
            $i++

        }   #End of if ($ParentObject)

    }   #End of foreach ($Ou in $Ous)


    #Dump custom OU info to XML file
    Export-Clixml -Path $CsvReport -InputObject $TotalOus

    #Message to screen
    Write-Host "OU information dumped to $CSVReport" 


}   #End of if ($Ous)
Else {

    #Write message to screen
    Write-Error -Message "Failed to retrieve OU information."


}   #End of else ($Ous)


Stop-Transcript