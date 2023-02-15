
# CalcMsgAverage.ps1 (version 1.0)
# Author Toomas Ruus (toomas.ruus@microsoft.com), Microsoft Estonia, Exchange PFE
# 
# Calculates e-mails sent/recieve per user and average message size from Exchange message tracking logs
# These values are useful with Exchange Server Role Requirements Calculator to find out hardware
# requirements and also useful information for organization
#
#
# ---- EXAMPLE 1 ----
# Calculate values using last 1 day from script start and only for servers E2K7 and E2K10
#
# CalcMsgAverage.ps1 -Servers "E2K7, E2K10"
#
#
# ---- EXAMPLE 2 ----
# Calculate values for 12 hours (0.5 days) starting from April 23, 2014 0:00, skip servers MBX1 and MBX2
# 
# CalcMsgAverage.ps1 0.5 -Start "2014-04-23" -SkipServers "MBX1, MBX2"
#
#
# ----EXAMPLE 3 ----
# Calculate values for 30 days before May 5, 2014 4:23 PM, skip Health Mailboxes
#
# CalcMsgAverage.ps1 -Period 30 -EndTime "05/05/2014 16:23" -SkipHealthMailboxes
#
#
# ---- EXAMPLE 4 ----
# Calculate values for all servers between 05/05/2014 4:23 PM and 05/07/2014 6:08 AM
#
# CalcMsgAverage.ps1 -StartTime "05/05/2014 4:23 PM" -EndTime "05/07/2014 6:08 AM"
#
#


[CmdletBinding()]
Param(
    [Parameter(Position=0)]
	[Double]$Period,
	
    [DateTime]$StartTime,

    [DateTime]$EndTime,

    [String]$Servers,

    [String]$SkipServers,

    [switch]$SkipHealthMailboxes,

    [switch]$Help,

    [switch]$Examples
)

# Display help syntax and/or examples and then exit
If ($Help -or $Examples) {
    If ($Help) {
        $HelpString = @"
SYNTAX
    CalcMsgAverage.ps1 [[-Period] <Double>] [-StartTime <DateTime>] [-EndTime <DateTime>] [-Servers <MultiValuedProperty> | -SkipServers <MultiValuedProperty>] [-SkipHealthMailboxes] [-Help]

"@
        Write-Host $HelpString
    }

    If ($Examples) {
        $HelpString = @"


    -------------------------- EXAMPLE 1 --------------------------

    Calculate values using last 1 day from script start and only for servers E2K7 and E2K10

    CalcMsgAverage.ps1 -Servers "E2K7, E2K10"


    -------------------------- EXAMPLE 2 --------------------------
    
    Calculate values for 12 hours (0.5 days) starting from April 23, 2014 0:00, skip servers MBX1 and MBX2

    CalcMsgAverage.ps1 0.5 -Start "2014-04-23" -SkipServers "MBX1, MBX2"


    -------------------------- EXAMPLE 3 --------------------------
    
    Calculate values for 30 days before May 5, 2014 4:23 PM, skip Health Mailboxes

    CalcMsgAverage.ps1 -Period 30 -EndTime "05/05/2014 16:23" -SkipHealthMailboxes


    -------------------------- EXAMPLE 4 --------------------------

    Calculate values for all servers between 05/05/2014 4:23 PM and 05/07/2014 6:08 AM

    CalcMsgAverage.ps1 -StartTime "05/05/2014 4:23 PM" -EndTime "05/07/2014 6:08 AM"


"@
        Write-Host $HelpString
    }

    Return
}

If (($StartTime -ne $null) -and ($EndTime -ne $null)) {
    If ($StartTime -ge $EndTime) {
        # $StartTime is bigger than $EndTime
        Write-Host -ForegroundColor Red "StartTime cannot be bigger or equal than EndTime"
        Return
    }

    # Both $StartTime and $EndTime has value defined, ignoring $Period current value and calculating its new value
    $Period = ([TimeSpan]($EndTime - $StartTime)).TotalDays
}
Else {
    $Period = [math]::Abs($Period)     # Change $Period value to positive
    If ($Period -eq 0) {$Period = 1}   # if $Period is 0 then use default value 1

    If (($StartTime -eq $null) -and ($EndTime -eq $null)) {
        # $StartTime and $EndTime both missing, set $EndTime and calculate $StartTime
        $EndTime = Get-Date
        $StartTime = $EndTime.AddDays(-$Period)
    }
    Else {
        # At least one of $StartTime or $EndTime has a value defined
        If ($EndTime -eq $null) {
            # $EndTime is not defined but $StartTime is defined, calculate $EndTime
            $EndTime = $StartTime.AddDays($Period)
        }
        Else {
            # $StartTime is not defined but $EndTime is defined, calculate $StartTime
            $StartTime = $EndTime.AddDays(-$Period)
        }
    }
}


# Get script start time
$ScriptStart = Get-Date 


$ExchangeServers = Get-ExchangeServer | select Name, Fqdn, IsHubTransportServer, IsMailboxServer, AdminDisplayVersion

$TransportServers = [System.Collections.ArrayList]($ExchangeServers | Where {$_.IsHubTransportServer -eq $true} | ForEach {$_.Name})

$Exchange2013Transport = [System.Collections.ArrayList]($ExchangeServers | Where {$_.AdminDisplayVersion -like "Version 15*" -and $_.IsHubTransportServer -eq $true} | ForEach {$_.Name})

If ($Servers.Length -ne 0) {
    # Checking -Servers parameter list

    # Remove spaces if necessary
    $ServersList = $Servers.Replace(" ","")

    # Remove trailing comma if necessary
    $ServersList = $ServersList.TrimEnd(",")

    # Remove domain part from servers name if necessary
    $ServersList = $ServersList -replace "(?:(?:\.(?:[A-z0-9-])+)+)(?=[,;]|)", ""

    # Change to uppercase
    $ServersList = $ServersList.ToUpper()

    # Split values to different rows
    $ServersList = [System.Collections.ArrayList]($ServersList -split "[,;]")

    # Check that given server names are valid as transport servers
    ForEach ($Server in $ServersList) {
        If (-not $TransportServers.Contains($Server)) {
            Write-Host -ForegroundColor Red "`nServer name '$Server' is not valid. Make sure there are no typing errors or the server has transport role or transport service available."
            Return
        }
    }

    # $Servers parameter list is verified and servers are valid, use it instead of default $TransportServers list
    $TransportServers = $ServersList
}
ElseIf ($SkipServers.Length -gt 0) {
    # Checking -SkipServers parameter list

    # Remove spaces if necessary
    $ServersList = $SkipServers.Replace(" ","")

    # Remove trailing comma if necessary
    $ServersList = $ServersList.TrimEnd(",")

    # Remove domain part from servers name if necessary
    $ServersList = $ServersList -replace "(?:(?:\.(?:[A-z0-9-])+)+)(?=[,;]|)", ""

    # Change to uppercase
    $ServersList = $ServersList.ToUpper()

    # Split values to different rows
    $ServersList = [System.Collections.ArrayList]($ServersList -split "[,;]")
    $SkipServersList = [System.Collections.ArrayList]$ServersList.Clone()

    # Check that list of skip server names are valid as transport servers
    ForEach ($Server in $ServersList) {
        If (-not $TransportServers.Contains($Server)) {
            Write-Host -ForegroundColor Red "`nSkipServers value '$Server' is not valid server, ignorning the value."
            $SkipServersList.Remove($Server)
        }
    }
}

If ($TransportServers.Count -eq 0) {
    Write-Host -ForegroundColor Yellow "No servers in list to analyze"
    Return
}


$AcceptedDomains = Get-AcceptedDomain | ForEach {$_.DomainName.Domain}
$AcceptedDomainsRgx = [regex]("(?:" + (($AcceptedDomains | ForEach {"@" + [regex]::Escape($_)}) -join "|") + ")")

$MbxServers = $ExchangeServers | Where {$_.IsMailboxServer -eq $true} | ForEach {$_.Fqdn}
$MbxServersRgx = [regex]("(?:" + (($MbxServers | Where {"@" + [regex]::Escape($_)}) -join "|") + ")\>")

$MessageIdRgx = "^\<.+@.+\..+\>$"
 

$ReceivedTotal = 0
[uint64]$ReceivedBytesTotal = 0

$SentUniqueTotal = 0
[uint64]$SentUniqueBytesTotal = 0


$ExchangeRecipients = @{}
 

Function TimeFeedback {
    Begin {
        # Constant Interval = 3
        New-Variable Interval -Option Constant -Value 3

        $RecordCount = 0
        $TotalTimer = [System.Diagnostics.Stopwatch]::StartNew()
        $IntervalTimer = [System.Diagnostics.Stopwatch]::StartNew()
    }
    Process {
        $RecordCount++
        If ($IntervalTimer.Elapsed.Seconds -ge $Interval) {
            Write-host “`rProcessed $RecordCount in $([int]$TotalTimer.Elapsed.TotalSeconds) seconds” -nonewline
            $IntervalTimer.Stop()
            $IntervalTimer.Reset()
            $IntervalTimer.Start()
        }
        $_
    }
    End {
        write-host “`rProcessed $RecordCount log records in $([int]$TotalTimer.Elapsed.TotalSeconds) seconds”
        $AverageRate = [int]($RecordCount/$TotalTimer.Elapsed.TotalSeconds)
        If ($TotalTimer.Elapsed.TotalSeconds -ne 0 -and $AverageRate -ne 0) {
            Write-Host "   Average rate: $AverageRate log recs/sec."
        }
    }
}


Write-Host "`nTracking start time: $StartTime"
Write-Host "Tracking end time:   $EndTime"
Write-Host "Analyzed period (days): $Period"


ForEach ($Server in $TransportServers){ 

    If ($SkipServersList -ne $null) {
        If ($SkipServersList.Contains($Server)) {
            Write-Host -ForegroundColor Yellow "`nSkipping server '$Server' as requested"
            Continue
        }
    }

    Write-Host "`nStarted processing $Server"


    If ($SkipHealthMailboxes -and $Exchange2013Transport.Contains($Server)) {
        # Skipping Health Mailboxes for calculation
        Write-Host -ForegroundColor Yellow "`nSkipping Health Mailboxes for server '$Server' as requested"

        Get-MessageTrackingLog -Server $Server -EventID DELIVER -Start $StartTime -End $EndTime -ResultSize Unlimited | TimeFeedback | 
        ForEach { 
    
     
		    If ($_.Source -eq "STOREDRIVER" -and $_.Recipients -notlike "HealthMailbox*") {
     
                If ($_.MessageId -imatch $MbxServersRgx -and $_.Sender -imatch $AcceptedDomainsRgx) {
				    ForEach ($Recipient in $_.Recipients) {
					    $ExchangeRecipients[$Recipient] ++
					    $ReceivedTotal ++
					    $ReceivedBytesTotal += $_.TotalBytes
                    }
                }
                ElseIf ($_.MessageId -imatch $MessageIdRgx) {
                    ForEach ($Recipient in $_.Recipients) {
					    $ExchangeRecipients[$Recipient] ++
						$ReceivedTotal ++
						$ReceivedBytesTotal += $_.TotalBytes
                    }
                }

            }

        }
 
    
	    Get-MessageTrackingLog -Server $Server -EventID RECEIVE -Start $StartTime -End $EndTime -ResultSize Unlimited | TimeFeedback | 
        ForEach {
	
		    If ($_.Source -eq "STOREDRIVER" -and $_.Recipients -notlike "HealthMailbox*") {
			    $ExchangeRecipients[$_.Sender] ++
			    $SentUniqueTotal ++
			    $SentUniqueBytesTotal += $_.TotalBytes
		    }

	    }

    }
    Else {
        # Normal calculation

        Get-MessageTrackingLog -Server $Server -EventID DELIVER -Start $StartTime -End $EndTime -ResultSize Unlimited | TimeFeedback | 
        ForEach {
    
     
		    If ($_.Source -eq "STOREDRIVER") {
     
			    If ($_.MessageId -imatch $MbxServersRgx -and $_.Sender -imatch $AcceptedDomainsRgx) {
				    ForEach ($Recipient in $_.Recipients) {
					    $ExchangeRecipients[$Recipient] ++
					    $ReceivedTotal ++
					    $ReceivedBytesTotal += $_.TotalBytes
				    }
			    }
                ElseIf ($_.MessageId -imatch $MessageIdRgx) {
                    ForEach ($Recipient in $_.Recipients) {
						$ExchangeRecipients[$Recipient] ++
						$ReceivedTotal ++
						$ReceivedBytesTotal += $_.TotalBytes
                    }
			    }
            }
		}
 
    
	    Get-MessageTrackingLog -Server $Server -EventID RECEIVE -Start $StartTime -End $EndTime -ResultSize Unlimited | TimeFeedback | 
        ForEach {
	
		    If ($_.Source -eq "STOREDRIVER") {
			    $ExchangeRecipients[$_.Sender] ++
			    $SentUniqueTotal ++
			    $SentUniqueBytesTotal += $_.TotalBytes
		    }
	    }

    }
     
}


$NumberOfRecipients = $ExchangeRecipients.Count

Write-Host "`n`nNumber of recipients: $NumberOfRecipients"

If ($NumberOfRecipients -eq 0) {
    # if recipients number is 0 then all averages are 0 also
    Write-Host -ForegroundColor Yellow "Nothing to analyze"
}
Else {

    If ($ReceivedTotal -eq 0) {
        # Nothing received, no need to calculate receive averages as it is 0
        $MsgReceivedPerMbxPerDay = 0
        $ReceivedKBTotalAverage = 0
    }
    Else {
        $ReceivedTotalAverage = $ReceivedTotal / $NumberOfRecipients

        $ReceivedKBTotalAverage = ($ReceivedBytesTotal / 1024) / $NumberOfRecipients / $ReceivedTotalAverage

        $MsgReceivedPerMbxPerDay = $ReceivedTotalAverage / $Period
    }

    If ($SentUniqueTotal -eq 0) {
        # Nothing sent, no need to calculate sent averages as it is 0
        $MsgSentPerMbxPerDay = 0
        $SentUniqueKBTotalAverage = 0
    }
    Else {
        $SentUniqueTotalAverage = $SentUniqueTotal / $NumberOfRecipients

        $SentUniqueKBTotalAverage = ($SentUniqueBytesTotal / 1024) / $NumberOfRecipients / $SentUniqueTotalAverage

        $MsgSentPerMbxPerDay = $SentUniqueTotalAverage / $Period
    }


    $MsgSentReceivedPerMbxPerDay = $MsgReceivedPerMbxPerDay + $MsgSentPerMbxPerDay

    $AverageMsgSize = ($ReceivedKBTotalAverage + $SentUniqueKBTotalAverage) / 2

    
    Write-Host "Messages Received per Mailbox Per Day: $('{0:F1}' -f $MsgReceivedPerMbxPerDay)"
    Write-Host "Messages Sent per Mailbox Per Day: $('{0:F1}' -f $MsgSentPerMbxPerDay)"
    Write-Host -ForegroundColor Green "Messages Sent/Received per Mailbox Per Day: $('{0:F1}' -f $MsgSentReceivedPerMbxPerDay)"

    Write-Host -ForegroundColor Green "Average message size (KB): $('{0:F1}' -f $AverageMsgSize)"
}


# Display script run time
$ScriptEnd = (Get-Date) - $ScriptStart
$ScriptRunDays = ""
If ($ScriptEnd.Days -gt 0) {
    $ScriptRunDays = $ScriptEnd.Days.ToString() + " day(s) and "
}
Write-Host "`nRun time was $ScriptRunDays$($ScriptEnd.Hours):$("{0:D2}" -f $ScriptEnd.Minutes):$("{0:D2}" -f $ScriptEnd.Seconds)`n"
