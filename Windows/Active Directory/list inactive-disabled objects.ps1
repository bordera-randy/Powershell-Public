
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 | select-object Name,lastlogondate,objectclass | Export-Csv $env:userprofile\Desktop\inactive-objects.csv

Search-ADAccount -AccountDisabled | select-object Name,lastlogondate,objectclass | Export-Csv $env:userprofile\Desktop\disabled-objects.csv

###################################################################################################

[datetime]$oneYearAgo = (Get-Date).AddDays("-$numberOfDaysInOneYear")
Search-ADAccount -AccountInactive -TimeSpan 365.00:00:00 | Where {$_.ObjectClass -eq 'user'} | Get-ADUser -Properties * | Where-object {$_.whencreated -lt $oneYearAgo } | select Name,lastlogondate,whencreated | Export-Csv $env:userprofile\Desktop\inactive-users.csv

###################################################################################################
Clear-Host 

Import-Module ActiveDirectory

$myDomain = Get-ADDomain
$myDomainName = $myDomain.NetBIOSname
$numberOfDaysInOneYear = 365
$numberOfDaysInThreeYears = 1095

$csvFilePath = "C:\ADPS\$($myDomainName)AccountsNotLoggedIntoIn$($numberOfDaysInThreeYears)Days.csv"

[datetime]$oneYearAgo = (Get-Date).AddDays("-$numberOfDaysInOneYear")
[datetime]$threeYearsAgo = (Get-Date).AddDays("-$numberOfDaysInThreeYears")

$userCollection = Search-ADAccount -AccountInactive -TimeSpan "$numberOfDaysInThreeYears.00:00:00" | Where {($_.ObjectClass -eq 'user') -and ($_.ObjectClass -ne 'computer')}

$userCollection | Get-ADUser -Properties * | Select Name, LastLogonDate,whenCreated,passwordLastSet,Description | Where {$_.whenCreated -le $oneYearAgo} | Export-Csv $csvFilePath -NoTypeInformation
###################################################################################################