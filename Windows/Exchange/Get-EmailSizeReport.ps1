function Get-EmailSizeReport {

    Param(
        [Parameter(Mandatory = $true)]
        [int] $Days,
        [Parameter(Mandatory = $true)]
        [string] $CSVOutputPath
        )

    $Start = [datetime]::Now.AddDays(-$Days)
    $End = [datetime]::Now
    $HTServers = @()
    Get-ExchangeServer | ? { `
    ($_.AdminDisplayVersion.Major -eq "15" -and $_.ServerRole -match "Mailbox") -or `
    ($_.AdminDisplayVersion.Major -eq "8" -and $_.ServerRole -match "HubTransport") -or `
    ($_.AdminDisplayVersion.Major -eq "14" -and $_.ServerRole -match "HubTransport") `
    } | % {$HTServers += $_.Name}

    $emails = @()
    foreach($HTServer in $HTServers)
        {
            $emails += Get-MessageTrackingLog -Start $Start -End $End -ResultSize Unlimited -Server $HTServer
        }

    $uniqueEmails = $emails | select MessageId -Unique

    $CSV = @()

    foreach($uniqueEmail in $uniqueEmails)
        {
            $email = @()
            $email = Get-MessageTrackingLog -MessageId $uniqueEmail.MessageId
            Write-Host "----------------------------------------------------------------------------------------------------" -ForegroundColor Green
            $email 
            if($email.Count)
                {
                    $CSVLine = New-Object System.Object
                    $CSVLine | Add-Member -Type NoteProperty -Name Date -Value $email[0].TimeStamp.ToShortDateString() -ErrorAction SilentlyContinue
                    $CSVLine | Add-Member -Type NoteProperty -Name Time -Value $email[0].TimeStamp.ToShortTimeString() -ErrorAction SilentlyContinue

                    $sender = $email[0].Sender
                    $recipients = @()
                    $email | ? {($_.Source -eq "Storedriver" -and $_.EventId -eq "Deliver") -or ($_.Source -eq "SMTP" -and $_.EventId -eq "Send")} |  % {$recipients += $_.Recipients}

                    $CSVLine | Add-Member -Type NoteProperty -Name Sender -Value $sender
                    $CSVLine | Add-Member -Type NoteProperty -Name Recipients -Value $recipients

                    #Figure out which emails are internal only
                    #if(Get all events for the unique email where not match STOREDRIVER).count less than 1 then the email is internal
                    if(!($email | ? {$_.Source -ne "STOREDRIVER"}))
                        {
                            $messageType = "Internal"
                            $messageDirection = "N/A"
                        }
                    else
                        {
                            $messageType = "External"
                            if($email | ? {$_.Source -eq "SMTP" -and $_.EventId -eq "Receive"})
                                {
                                    $messageDirection = "Inbound"
                                }
                            if($email | ? {$_.Source -eq "SMTP" -and $_.EventId -eq "Send"})
                                {
                                    $messageDirection = "Outbound"
                                }
                        }

                    $CSVLine | Add-Member -Type NoteProperty -Name MessageType -Value $messageType
                    $CSVLine | Add-Member -Type NoteProperty -Name MessageDirection -Value $messageDirection
                    $CSVLine | Add-Member -Type NoteProperty -Name MessageSubject -Value $email[0].MessageSubject -ErrorAction SilentlyContinue
                    $CSVLine | Add-Member -Type NoteProperty -Name MessageSizeInBytes -Value (("{0:N0}" -f ($email[0].TotalBytes / 1kb)) -replace ",","")
                    $CSVLine | Add-Member -Type NoteProperty -Name MessageSizeInMegaBytes -Value (("{0:N0}" -f ($email[0].TotalBytes / 1mb)) -replace ",","")

                    $CSV += $CSVLine
                }
        }



    $CSV | select Date,Time,Sender,@{Name='Recipients';Expression={[string]::join(";", ($_.recipients))}},MessageType,MessageDirection,MessageSubject,MessageSizeInBytes,MessageSizeInMegaBytes `
    | Export-Csv -NoTypeInformation $CSVOutputPath

}


