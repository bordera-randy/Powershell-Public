$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://ExchangeServer.Domain.com/PowerShell/" -Authentication Kerberos
Import-PSSession $Session -AllowClobber
Set-ADServerSettings -ViewEntireForest $True
$StartDate = (Get-Date).AddDays('-30').ToString("MM/dd/yyyy HH:mm")
$TodaystDate = (Get-Date).AddDays('0').ToString("MM/dd/yyyy HH:mm")
$ExchangeServers = Get-TransportService
$LogArray = new-object system.collections.arraylist

ForEach ($Server in $ExchangeServers)
{
$TrackingLog = Get-MessageTrackingLog -Server $Server.Name -Start $StartDate –End $TodaystDate -EventID Expand -ResultSize Unlimited | Select Timestamp, RelatedRecipientAddress| Group-Object RelatedRecipientAddress
ForEach ($logEntry in $TrackingLog)
{
$PickLatest = $logEntry.Group | Sort-Object TimeStamp -Descending | Select -First 1
$ArrayObj = [pscustomobject]@{
			Timestamp = $PickLatest.Timestamp
			DL = $PickLatest.RelatedRecipientAddress
		}
		$LogArray.Add($ArrayObj) | Out-Null
}
}
$AllServerLogs = $LogArray | Group-Object DL
$AllServerLogArray = new-object system.collections.arraylist
ForEach ($i in $AllServerLogs)
{
$PickLatestOfAllServers = $i.Group | Sort-Object TimeStamp -Descending | Select -First 1
$ArrayObj = [pscustomobject]@{
			Timestamp = $PickLatestOfAllServers.Timestamp
			DL = $PickLatestOfAllServers.DL
		}
		$AllServerLogArray.Add($ArrayObj) | Out-Null
}

#======= Stamp
$DLCount = 0
$ErrorLogArray = new-object system.collections.arraylist
$StampedLogArray = new-object system.collections.arraylist
ForEach ($DL in $AllServerLogArray)
{
$DistributionList = Get-DistributionGroup -Identity $DL.DL -ErrorAction Continue
if ((!($DistributionList.CustomAttribute1)) -or ($DistributionList.CustomAttribute1 -lt $DL.Timestamp))
{
Try
{
Set-DistributionGroup $DL.DL -CustomAttribute1 $DL.Timestamp  -ErrorAction Stop -ForceUpgrade -MemberDepartRestriction Closed
$ArrayObj = [pscustomobject]@{
			DistributionList = $DL.DL
			TimeStamp = $DL.Timestamp
		}
		$StampedLogArray.Add($ArrayObj) | Out-Null
$DLCount ++
Write-Host "$DLCount Stamped" -ForegroundColor Green
}
Catch
{
Write-Host "Error" -ForegroundColor Red
$ArrayObj = [pscustomobject]@{
			DistributionList = $DL.DL
			Error = $_.Exception.Message
		}
		$ErrorLogArray.Add($ArrayObj) | Out-Null
}
} 
}

#==== Send Report
$HeaderStamp = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
$StampReport = $StampedLogArray | ConvertTo-Html -Head $HeaderStamp

$HeaderError = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #FF0000;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
$ErrorReport = $ErrorLogArray | ConvertTo-Html -Head $HeaderError

$smtp = ""

$to = ""

$from = ""

$subject = "Distribution List Time Stamp" 

$body = "<b><font color=red>Distribution List Time Stamp</b></font> <br>"

$body += "This scheduled task is completed.There are <b><font color=Green>$DLCount</b></font>, Distribution Lists that are stamped, and There are <b><font color=Red>$($ErrorLogArray.count)</b></font> Distribution Lists that did not stamp due to errors.<br>Please Refer to Reports Bellow for both Stamped and Errors if there are any <br><br><b>Stamped Distribution Lists:</b><br>$StampReport <br><br><b>The following Errors prevented the stamp</b> $ErrorReport"

send-MailMessage -SmtpServer $smtp -To $to -From $from -Subject $subject -Body $body -BodyAsHtml
Remove-PSSession $Session