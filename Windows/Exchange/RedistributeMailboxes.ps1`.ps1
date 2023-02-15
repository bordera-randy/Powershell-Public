#Author: Riaz A Ansary
$Exchange = Read-Host "`n`n`nEnter the FQDN of one of the exchange servers in your organization for establishing PsSession"
Try
{
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$Exchange/PowerShell/" -ErrorAction Stop
	Import-PSSession $Session -AllowClobber -ErrorAction Stop
}
Catch
{
	Write-Host "Please Enter a valid exchange server name. PsSession was not established" -ForegroundColor Red
	Exit
}
Set-ADServerSettings -ViewEntireForest $True
$DBVariableArray = new-object system.collections.arraylist
$MailboxMovingFromArray = new-object system.collections.arraylist
$MailboxMovingToArray = new-object system.collections.arraylist
$MailboxesToMoveArray = new-object system.collections.arraylist
$FinalMailboxesReportArray = new-object system.collections.arraylist
$MoveInitiatedArray = new-object system.collections.arraylist
$errorlogArray = new-object system.collections.arraylist
$DBs = Get-MailboxDatabase | Sort Name
$LogPath = Read-Host "`n`n`nEnter the path for log files - IMPORTANT: Please Make Sure The Path has no other CSV File in it"
[int]$MBXCountTotal = 0
[int]$NumberOfMailboxes = 0
[int]$Ratio = 0
$Confirmation = $Null
While ($Confirmation -ne 'Y')
{
	$Confirmation = Read-Host -Prompt 'Did you confirm that there are no other csv files in the path you provided above? Enter Y for Yes!'
}

Write-Warning "Microsoft Excel is required to combine multiple log reports into one!"
#Extracting Number of mailboxes in each database

Write-Host "`nGetting number of mailboxes in each database ...`n" -BackgroundColor Yellow -ForegroundColor Black
foreach ($i in $DBs)
{
	[int]$MBXCount = (Get-Mailbox -Database $i.Name -ResultSize Unlimited -WarningAction SilentlyContinue | Measure-Object).count
	write-host " $MBXCount Mailboxes in $($i.Name)" -ForegroundColor Green
	$MBXCountTotal += $MBXCount
	
	$ArrayObj = [pscustomobject]@{
		Database = $i.Name
		Mailboxes = $MBXCount
	}
	$DBVariableArray.Add($ArrayObj) | Out-Null
	
}

#Calculating number of mailboxes per database ratio

Write-Host "`nCalculating number of mailboxes per database ratio ...`n" -BackgroundColor Yellow -ForegroundColor Black
$Ratio = [math]::Round($MBXCountTotal/$DBs.Count, 0)
Write-Host " Each database need to hold $Ratio mailboxes" -ForegroundColor Green
Clear-Variable i
Clear-Variable ArrayObj
Write-Host "`nGathering Databases that needs Mailboxes to move from ..." -BackgroundColor Yellow -ForegroundColor Black
ForEach ($i in $DBVariableArray)
{
	if ($i.Mailboxes -gt $Ratio)
	{
		[int]$NumberOfMailboxes = $i.Mailboxes - $Ratio
		$ArrayObj = [pscustomobject]@{
			MailboxMovingFrom = $i.Database
			NumberOfMailboxesToMove = $NumberOfMailboxes
		}
		$MailboxMovingFromArray.Add($ArrayObj) | Out-Null
	}
	elseif ($i.Mailboxes -lt $Ratio)
	{
		$NumberOfMailboxesCanTake = $Ratio - $i.Mailboxes
		$ArrayObj = [pscustomobject]@{
			MailboxMovingTo = $i.Database
			NumberOfMailboxesCanTake = $NumberOfMailboxesCanTake
		}
		$MailboxMovingToArray.Add($ArrayObj) | Out-Null
	}
}
[int]$TotalMovingFrom = ($MailboxMovingFromArray | Measure-Object -Sum 'NumberOfMailboxesToMove').sum
$MailboxMovingFromArray | Export-Csv $LogPath\MoveFrom.csv -NoTypeInformation
Write-Host "`n Total of $TotalMovingFrom mailboxes need moving" -ForegroundColor Green
$MailboxMovingFromArray | FT

[int]$TotalMovingTO = ($MailboxMovingToArray | Measure-Object -Sum 'NumberOfMailboxesCanTake').sum
$MailboxMovingToArray | Export-Csv $LogPath\MoveTo.csv -NoTypeInformation
Write-Host " Total of $TotalMovingTO mailboxes that can other databases take based on ratio per database " -ForegroundColor Green
$MailboxMovingToArray | FT

[int]$TotalDatabaseMovingTO = ($MailboxMovingToArray | Measure-Object).count
Clear-Variable i
Clear-Variable ArrayObj

# Extracting required number of mailnoxes from each database

Write-Host "`nExtracting required number of mailboxes from each databases ...`n" -BackgroundColor Yellow -ForegroundColor Black
ForEach ($i in $MailboxMovingFromArray)
{
	$Loop = 0
	$Counter = 0
	$MBXs = Get-Mailbox -Database $i.MailboxMovingFrom -ResultSize Unlimited -WarningAction SilentlyContinue
	
	ForEach ($MBX in $MBXs)
	{
		
		$ArrayObj = [pscustomobject]@{
			Number = $loop
			DisplayName = $MBX.DisplayName
			PrimarySMTPAddress = $MBX.PrimarySmtpAddress
			CurrentDataBase = $MBX.Database
		}
		$MailboxesToMoveArray.Add($ArrayObj) | Out-Null
		$Loop++
		$Counter++
		if ($loop -eq $i.NumberOfMailboxesToMove)
		{
			Break
		}
	}
	Write-Host " $Counter mailboxes is extracted from $($i.MailboxMovingFrom)" -ForegroundColor Green
}
$MailboxesToMoveArray | Export-Csv $LogPath\ToMove.csv -NoTypeInformation
Clear-Variable i
Clear-Variable ArrayObj
Clear-Variable Loop
Clear-Variable Counter

#Final Report
Write-Host "`nCalculating and generating Final Report ...`n" -BackgroundColor Yellow -ForegroundColor Black
ForEach ($i in $MailboxMovingToArray)
{
	$Loop = 0
	$Counter = 0
	ForEach ($Mailbox in $MailboxesToMoveArray.ToArray())
	{
		$ArrayObj = [pscustomobject]@{
			Number = $Mailbox.Number
			DisplayName = $MailBox.DisplayName
			PrimarySMTPAddress = $Mailbox.PrimarySMTPAddress
			CurrentDataBase = $Mailbox.CurrentDataBase
			DistinationDatabase = $i.MailboxMovingTo
		}
		$FinalMailboxesReportArray.Add($ArrayObj) | Out-Null
		$MailboxesToMoveArray.Remove($Mailbox) | Out-Null
		$Loop++
		$Counter++
		if ($Loop -eq $i.NumberOfMailboxesCanTake)
		{
			Break
		}
	}
	Write-Host " $Counter mailboxes database Distination is set to $($i.MailboxMovingTo)" -ForegroundColor Green
}
Clear-Variable i
Clear-Variable ArrayObj
Clear-Variable Loop
Clear-Variable Counter
$FinalMailboxesReportArray | Export-Csv $LogPath\FinalReport.csv -NoTypeInformation

#Merge all Log files info one report 
Write-Host "`nMerging multiple reports into one called 'FinalReportCombined' ...`n" -BackgroundColor Yellow -ForegroundColor Black
Try
{
	$ErrorActionPreference = 'Stop'
	$CSVPath = "$LogPath" ## Soruce CSV Folder
	$XLOutput = "$LogPath\FinalReportCombined.xlsx" ## Output file name
	
	
	$csvFiles = Get-ChildItem ("$CSVPath\*") -Include *.csv
	$Excel = New-Object -ComObject excel.application
	$Excel.visible = $False
	$Excel.sheetsInNewWorkbook = $csvFiles.Count
	$workbooks = $excel.Workbooks.Add()
	$CSVSheet = 1
	
	Foreach ($CSV in $Csvfiles)
	{
		$worksheets = $workbooks.worksheets
		$CSVFullPath = $CSV.FullName
		$SheetName = ($CSV.name -split "\.")[0]
		$worksheet = $worksheets.Item($CSVSheet)
		$worksheet.Name = $SheetName
		$TxtConnector = ("TEXT;" + $CSVFullPath)
		$CellRef = $worksheet.Range("A1")
		$Connector = $worksheet.QueryTables.add($TxtConnector, $CellRef)
		$worksheet.QueryTables.item($Connector.name).TextFileCommaDelimiter = $True
		$worksheet.QueryTables.item($Connector.name).TextFileParseType = 1
		$worksheet.QueryTables.item($Connector.name).Refresh()
		$worksheet.QueryTables.item($Connector.name).delete()
		$worksheet.UsedRange.EntireColumn.AutoFit()
		$CSVSheet++
		
	}
	
	$workbooks.SaveAs($XLOutput, 51)
	$workbooks.Saved = $true
	$workbooks.Close()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbooks) | Out-Null
	$excel.Quit()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
	[System.GC]::Collect()
	[System.GC]::WaitForPendingFinalizers()
	Write-Host "`nCalculation and reporting is completed! Review the FinalReport.csv file and continue rebalacing`n`n" -BackgroundColor DarkGreen
}
catch
{
	Write-Host "`nMicrosoft Excel is NOT installed on this server, logs are not combined you can view them seperately in $LogPath`n`n" -BackgroundColor Magenta -ForegroundColor White
}

$Confirmation = $Null
While ($Confirmation -ne 'Y')
{
	$Confirmation = Read-Host -Prompt 'Are you ready to Re-Balance the databases? Enter Y for Yes!, X to Exit'
	if ($Confirmation -eq 'X')
	{
		exit
	}
}

#Moving Milboxes
$HowMany = $Null
While (($HowMany -ne 'Y') -and ($HowMany -ne 'N'))
{
	$HowMany = Read-Host -Prompt 'Do you want to move all Mailboxes reported? Enter Y for Yes!, N for No'
}


if ($HowMany -eq 'Y')
{
	Write-Host "`nRe-Balancing Databases' ...`n" -BackgroundColor Yellow -ForegroundColor Black
	$BatchName = "Rebalancing-$Date"
	ForEach ($i in $FinalMailboxesReportArray)
	{
		try
		{
			New-MoveRequest -Identity $i.PrimarySMTPAddress -TargetDatabase $i.DistinationDatabase -BatchName $BatchName -BadItemLimit 1000 -WarningAction SilentlyContinue -ErrorAction Stop
		}
		catch
		{
			$ArrayObj = [pscustomobject]@{
				Name = [String]$i.DisplayName
				PrimarySMTPAddress = [String]$i.PrimarySMTPAddress
				Error = [string]$_.exception.message
			}
			$errorlogArray.Add($ArrayObj) | Out-Null
		}
	}
	$errorlogArray | Export-Csv $LogPath\ErrorLog.csv -NoTypeInformation
	Write-Host "`nMove command initiated for the mailboxes please check $LogPath for ErrorLog.Csv if there are any with errors" -BackgroundColor DarkGreen
}


if ($HowMany -eq 'N')
{
	try
	{
		[int]$NumberToMove = Read-Host "Enter the number of mailboxes you want to move" -ErrorAction Stop
	}
	Catch
	{
		Write-Host "You did not enter a valid number" -BackgroundColor Red
		exit
	}
	if ($NumberToMove -eq 0)
	{
		Write-Host "You entered $NumberToMove, no move initiated" -BackgroundColor DarkGreen
		exit
	}
	Write-Host "`nRe-Balancing Databases' ...`n" -BackgroundColor Yellow -ForegroundColor Black
	$Date = (Get-Date)
	$BatchName = "Rebalancing-$Date"
	$Counter = 0
	ForEach ($i in $FinalMailboxesReportArray)
	{
		$Counter++
		try
		{
			New-MoveRequest -Identity $i.PrimarySMTPAddress -TargetDatabase $i.DistinationDatabase -BatchName $BatchName -BadItemLimit 1000 -WarningAction SilentlyContinue -ErrorAction Stop
			$MoveObj = [pscustomobject]@{
				Name = [String]$i.DisplayName
				PrimarySMTPAddress = [String]$i.PrimarySMTPAddress
				CurrentDataBase = [string]$i.CurrentDataBase
				DistinationDatabase = [string]$i.DistinationDatabase
			}
			$MoveInitiatedArray.Add($MoveObj) | Out-Null
		}
		catch
		{
			$ArrayObj = [pscustomobject]@{
				Name = [String]$i.DisplayName
				PrimarySMTPAddress = [String]$i.PrimarySMTPAddress
				Error = [string]$_.exception.message
			}
			$errorlogArray.Add($ArrayObj) | Out-Null
		}
		if ($Counter -eq $NumberToMove)
		{
			break
		}
	}
	$errorlogArray | Export-Csv $LogPath\ErrorLog.csv -NoTypeInformation
	$MoveInitiatedArray | Export-Csv "$LogPath\MoveInitiated.csv" -NoTypeInformation
	Write-Host "`nMove command initiated for the mailboxes please check $LogPath for ErrorLog.Csv if there are any with errors" -BackgroundColor DarkGreen
}
