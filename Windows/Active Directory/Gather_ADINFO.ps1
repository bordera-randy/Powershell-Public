######################################################
#     
#     Description:    This script will gather data on the active directory environment
#     Author:         Randy Bordeaux
#     Date Created:   6/9/2020
#
######################################################

# import modules 
import-module activedirectory

# Variables
$csvpath = c:\AD_Info\


write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Creating Folder C:\AD_Info"
# folder
mkdir c:\AD_Info

write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Gathering user information..." 
write-host -ForegroundColor DarkRed -BackgroundColor Yellow ""
# Export users 
get-aduser -filter * -Properties * | export-csv -NoTypeInformation c:\AD_Info\adusers.csv
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "User information has been exported to a .csv file"
write-host -ForegroundColor DarkRed -BackgroundColor Yellow ""
write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Starting Group membership retrieval... "
# Get Groups and group memberships

# Get year and month for csv export file
$DateTime = Get-Date -f "yyyy-MM"

# Set CSV file name
$CSVFile = "C:\AD_Info\AD_Groups"+$DateTime+".csv"

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
$CSVOutput | Sort-Object Name | Export-Csv $CSVFile -NoTypeInformation

write-host -ForegroundColor DarkRed -BackgroundColor Yellow "Group membership retrieval completed"


write-host -ForegroundColor DarkRed -BackgroundColor Yellow " Gathering Domain Info..."
get-addomain | export-csv -NoTypeInformation $csvpath +=domain.csv

