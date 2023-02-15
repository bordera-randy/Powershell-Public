<#---------------------------------------------
Exchange2013-MoveLoggingPaths.ps1
---------------------------------------------
Version 1.0 by KSB
Version 1.1 by ALM
This script will move all of the configurable logs for Exchange 2013 from the C: drive
to a new path. The folder subtree and paths on L: will stay the same as they were on C:

ALM:
- Changed script file name to correspond with my naming convention
- Added variable for new base log file path
- Updated comments
- Added code to move existing Log files to new path
- Added changes recommended in the original post comments section
- Added IIS log files move
- Added logic to Move Transport DB - Mail.que location (if desired)
- Added a few more log paths
#>

# Get the name of the local computer and set it to a variable for use later on.
$ExchangeServerName = $env:COMPUTERNAME

# Set base paths for log files locations
$NewLogPath = "E:\Exchange\LogFiles" # "L:\Program Files\Microsoft\Exchange Server\V15"
$OldLogPath = $env:ExchangeInstallPath # "C:\Program Files\Microsoft\Exchange Server\V15"
$NewIISLogPath = "E:\IIS\LogFiles"
$OldIISLogPath = $env:SystemDrive\inetpub\logs\LogFiles

# IF set $MoveQue = $true then move location of Transport DB (mail.que)
$MoveQue = $false
IF ($MoveQue) {$EXScripts = "$OldLogPath\Scripts"
CD $EXScripts
$ExchTDBPath = "J:\Exchange\TransportRoles\data"
.\Move-TransportDatabase.ps1 -queueDatabasePath "$ExchTDBPath\Queue" -queueDatabaseLoggingPath "$ExchTDBPath\Queue" -iPFilterDatabasePath "$ExchTDBPath\IpFilter" -iPFilterDatabaseLoggingPath "$ExchTDBPath\IpFilter" -temporaryStoragePath "$ExchTDBPath\Temp"}

#Define logging subfolders
$ExchLogPaths = @("Logging\Calendar Repair Assistant")
$ExchLogPaths += "Logging\Diagnostics\AnalyzerLogs"
$ExchLogPaths += "Logging\Diagnostics\CertificateLogs"
$ExchLogPaths += "Logging\Diagnostics\CosmosLog"
$ExchLogPaths += "Logging\Diagnostics\DailyPerformanceLogs"
$ExchLogPaths += "Logging\Diagnostics\Dumps"
$ExchLogPaths += "Logging\Diagnostics\EtwTraces"
$ExchLogPaths += "Logging\Diagnostics\PerformanceLogsToBeProcessed"
$ExchLogPaths += "Logging\Diagnostics\Poison"
$ExchLogPaths += "Logging\Diagnostics\ServiceLogs"
$ExchLogPaths += "Logging\Diagnostics\Store"
$ExchLogPaths += "Logging\Diagnostics\TraceArchive"
$ExchLogPaths += "Logging\Diagnostics\Watermarks"
$ExchLogPaths += "Logging\Imap4"
$ExchLogPaths += "Logging\IRMLogs"
$ExchLogPaths += "Logging\Managed Folder Assistant"
$ExchLogPaths += "Logging\MigrationLogs"
$ExchLogPaths += "Logging\Pop3"
$ExchLogPaths += "TransportRoles\Logs\EdgeSync"
$ExchLogPaths += "TransportRoles\Logs\FrontEnd\AgentLog"
$ExchLogPaths += "TransportRoles\Logs\FrontEnd\Connectivity"
$ExchLogPaths += "TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive"
$ExchLogPaths += "TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend"
$ExchLogPaths += "TransportRoles\Logs\Hub\ActiveUsersStats"
$ExchLogPaths += "TransportRoles\Logs\Hub\AgentLog"
$ExchLogPaths += "TransportRoles\Logs\Hub\Connectivity"
$ExchLogPaths += "TransportRoles\Logs\Hub\PipelineTracing"
$ExchLogPaths += "TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive"
$ExchLogPaths += "TransportRoles\Logs\Hub\ProtocolLog\SmtpSend"
$ExchLogPaths += "TransportRoles\Logs\Hub\QueueViewer"
$ExchLogPaths += "TransportRoles\Logs\Hub\Routing"
$ExchLogPaths += "TransportRoles\Logs\Hub\ServerStats"
$ExchLogPaths += "TransportRoles\Logs\Hub\WLM"
$ExchLogPaths += "TransportRoles\Logs\JournalLog"
$ExchLogPaths += "TransportRoles\Logs\Mailbox\AgentLog\Delivery"
$ExchLogPaths += "TransportRoles\Logs\Mailbox\AgentLog\Submission"
$ExchLogPaths += "TransportRoles\Logs\Mailbox\Connectivity"
$ExchLogPaths += "TransportRoles\Logs\Mailbox\PipelineTracing"
$ExchLogPaths += "TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive"
$ExchLogPaths += "TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend"
$ExchLogPaths += "TransportRoles\Logs\MessageTracking"
$ExchLogPaths += "TransportRoles\Pickup"
$ExchLogPaths += "TransportRoles\Replay"
$IISLogPaths = @("W3SVC1")
$IISLogPaths += "W3SVC2"

# Create new log folders
FOREACH ($ExchLogPath in $ExchLogPaths) {New-Item -Path $NewLogPath -Name $ExchLogPath -ItemType "Directory"}
FOREACH ($IISLogPath in $IISLogPaths) {New-Item -Path $NewLogPath -Name "$NewIISLogPath\$IISLogPath" -ItemType "Directory"}

# Pre Move Existing log files from old path to new path - To save time moving while Services are stopped.  If folder doesn't exist then move will fail.
FOREACH ($ExchLogPath in $ExchLogPaths) {Get-ChildItem -Path "$OldLogPath\$ExchLogPath\*" | Move-Item -Destination "$NewLogPath\$ExchLogPath"}
FOREACH ($IISLogPath in $IISLogPaths) {Get-ChildItem -Path "$env:SystemDrive\inetpub\logs\LogFiles\$IISLogPath\*" | Move-Item -Destination "$NewLogPath\IIS\$IISLogPath"}

# Stop All MS Exchange Services
Get-Service -Name “MSExchange*” | ?{$_.Status -eq 'Running'} | Stop-Service -Force

# Move the path for the PERFMON logs from the C: drive to the new path
REG ADD HKLM\SOFTWARE\Microsoft\ExchangeServer\v15\Diagnostics /v LogFolderPath /t REG_SZ /d "$NewLogPath\Logging\Diagnostics"

<# ORIGINAL CODE TO MOVE PERFMON LOGGING
logman -stop ExchangeDiagnosticsDailyPerformanceLog
logman -update ExchangeDiagnosticsDailyPerformanceLog -o "$NewLogPath\Logging\Diagnostics\DailyPerformanceLogs\ExchangeDiagnosticsDailyPerformanceLog"
logman -start ExchangeDiagnosticsDailyPerformanceLog
logman -stop ExchangeDiagnosticsPerformanceLog
logman -update ExchangeDiagnosticsPerformanceLog -o "$NewLogPath\Logging\Diagnostics\PerformanceLogsToBeProcessed\ExchangeDiagnosticsPerformanceLog"
logman -start ExchangeDiagnosticsPerformanceLog
#>

# Move the standard log files for the TransportService to new path
Set-TransportService -Identity $ExchangeServerName `
-ConnectivityLogPath "$NewLogPath\TransportRoles\Logs\Hub\Connectivity" `
-MessageTrackingLogPath "$NewLogPath\TransportRoles\Logs\MessageTracking" `
-IrmLogPath "$NewLogPath\Logging\IRMLogs" `
-ActiveUserStatisticsLogPath "$NewLogPath\TransportRoles\Logs\Hub\ActiveUsersStats" `
-ServerStatisticsLogPath "$NewLogPath\TransportRoles\Logs\Hub\ServerStats" `
-ReceiveProtocolLogPath "$NewLogPath\TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive" `
-RoutingTableLogPath "$NewLogPath\TransportRoles\Logs\Hub\Routing" `
-SendProtocolLogPath "$NewLogPath\TransportRoles\Logs\Hub\ProtocolLog\SmtpSend" `
-QueueLogPath "$NewLogPath\TransportRoles\Logs\Hub\QueueViewer" `
-WlmLogPath "$NewLogPath\TransportRoles\Logs\Hub\WLM" `
-PipelineTracingPath "$NewLogPath\TransportRoles\Logs\Hub\PipelineTracing" `
-AgentLogPath "$NewLogPath\TransportRoles\Logs\Hub\AgentLog" `
-PickupDirectoryPath "$NewLogPath\TransportRoles\Pickup" `
-ReplayDirectoryPath "$NewLogPath\TransportRoles\Replay" `
-JournalLogPath "$NewLogPath\TransportRoles\Logs\JournalLog"

# Get the details on the EdgeSyncServiceConfig and store them in a variable for use in setting the path
$EdgeSyncServiceConfigVAR=Get-EdgeSyncServiceConfig

# Move the Log Path using the variable we got
Set-EdgeSyncServiceConfig -Identity $EdgeSyncServiceConfigVAR.Identity -LogPath "$NewLogPath\TransportRoles\Logs\EdgeSync"

# Move the standard log files for the FrontEndTransportService to the new path
Set-FrontendTransportService -Identity $ExchangeServerName `
-AgentLogPath "$NewLogPath\TransportRoles\Logs\FrontEnd\AgentLog" `
-ConnectivityLogPath "$NewLogPath\TransportRoles\Logs\FrontEnd\Connectivity" `
-ReceiveProtocolLogPath "$NewLogPath\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive" `
-SendProtocolLogPath "$NewLogPath\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend" `

# Move the log path for the IMAP server
Set-ImapSettings -LogFileLocation "$NewLogPath\Logging\Imap4"

# Move the logs for the MailBoxServer
Set-MailboxServer -Identity $ExchangeServerName `
-CalendarRepairLogPath "$NewLogPath\Logging\Calendar Repair Assistant" `
-MigrationLogFilePath "$NewLogPath\Logging\MigrationLogs" `
-LogPathForManagedFolders "$NewLogPath\Logging\Managed Folder Assistant"

# Move the standard log files for the MailboxTransportService to the same path on the new path
Set-MailboxTransportService -Identity $ExchangeServerName `
-ConnectivityLogPath "$NewLogPath\TransportRoles\Logs\Mailbox\Connectivity" `
-MailboxDeliveryAgentLogPath "$NewLogPath\TransportRoles\Logs\Mailbox\AgentLog\Delivery" `
-MailboxSubmissionAgentLogPath "$NewLogPath\TransportRoles\Logs\Mailbox\AgentLog\Submission" `
-ReceiveProtocolLogPath "$NewLogPath\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive" `
-SendProtocolLogPath "$NewLogPath\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend" `
-PipelineTracingPath "$NewLogPath\TransportRoles\Logs\Mailbox\PipelineTracing"

# Move the log path for the POP3 server
Set-PopSettings -LogFileLocation "$NewLogPath\Logging\Pop3"

# Stop IIS Services
Stop-Service "W3C Logging Service"
Stop-Service "World Wide Web Publishing Service"

# Move IIS Log Files for existing websites !!! NOTE !!! WILL NOT MOVE DEFAULT LOCATION FOR NEW SITES AFTER THIS IS RUN !!!
Import-Module WebAdministration
Get-WebSite | FOREACH {Set-ItemProperty "IIS:\Sites\$($_.name)" -name logFile.directory -value "$NewLogPath\IIS"}

# Move Remaining Existing log files from old path to new path
FOREACH ($ExchLogPath in $ExchLogPaths) {Get-ChildItem -Path "$OldLogPath\$ExchLogPath\*" | Move-Item -Destination "$NewLogPath\$ExchLogPath"}
FOREACH ($IISLogPath in $IISLogPaths) {Get-ChildItem -Path "$OldIISLogPath\$IISLogPath\*" | Move-Item -Destination "$NewIISLogPath\$IISLogPath"}

# Restart Services
Get-Service -Name “MSExchange*” | ?{$_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic'} | Start-Service
Start-Service "World Wide Web Publishing Service"
Start-Service "W3C Logging Service"
