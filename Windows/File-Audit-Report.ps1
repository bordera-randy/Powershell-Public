<##################################################################################################
    Name:           File-Audit-Report.ps1
    Created By:     Randy Bordeaux (randy@randybordeaux.com)
    Date Created:   7/7/2021
    Date Modified: 
    Description: 
        This script will generate a file audit report.

    Documentation:
     
    https://www.powershellgallery.com/packages/NTFSSecurity/4.2.6

##################################################################################################>

<# Error handling #>
$error.Clear()
$ErrorActionPreference = 'silentlycontinue'

<# Modules #>
Install-Module PSHTML

<# Main #>
mkdir c:\tmp\
$events = Get-WinEvent -FilterHashtable @{

    LogName = 'Security'

    Id = 4663,5140

    StartTime = (Get-Date).AddDays(-7)

}

$dataHt = @{}
$ex.Event.EventData.Data | %{$dataHt[$_.Name] = $_.'#text'}
$dataHt['ObjectName']
enum AccessType {
    ReadData_ListDirectory = 4416
    WriteData_AddFile = 4417
    AppendData_AddSubdirectory_CreatePipeInstance = 4418
    ReadEA = 4419
    WriteEA = 4420
    Execute_Traverse = 4421
    DeleteChild = 4422
    ReadAttributes = 4423
    WriteAttributes = 4424
    DELETE = 1537
    READ_CONTROL = 1538
    WRITE_DAC = 1539
    WRITE_OWNER = 1540
    SYNCHRONIZE = 1541
    ACCESS_SYS_SEC = 1542
}
$ats = foreach ($stringMatch in ($dataHt['AccessList'] | Select-String -Pattern '\%\%(?<id>\d{4})' -AllMatches)) {
    foreach ($group in $stringMatch.Matches.Groups | ?{$_.Name -eq 'id'}) {
        [AccessType]$group.Value
    }
}
$report = foreach ($event in $events | Sort TimeCreated) {
    [xml]$ex = $event.ToXML()
    $dataHt = @{}
    $ex.Event.EventData.Data | %{$dataHt[$_.Name] = $_.'#text'}
    $ats = foreach ($stringMatch in ($dataHt['AccessList'] | Select-String -Pattern '\%\%(?<id>\d{4})' -AllMatches)) {
    foreach ($group in $stringMatch.Matches.Groups | ?{$_.Name -eq 'id'}) {
            [AccessType]$group.Value
        }
    }
    [pscustomobject]@{
        Time = $event.TimeCreated
        EventId = $event.Id
        LogonID = $dataHt['SubjectLogonId']
        Path = "$($dataHt['ObjectName'])".trim('\??\')
        Share = $dataHt['ShareName']
        User = $dataHt['SubjectUserName']
        UserDomain = $dataHt['SubjectDomainName']
        IpAddress = $dataHt['IpAddress']
        AccessType = $ats -join ', '
    }
}
$ipCache = @{}

$report = foreach ($event in $events | Sort TimeCreated) {
    ...
    if ($event.Id -eq 5140) {
        $ipCache[$dataHt['SubjectLogonId']] = $dataHt['IpAddress']
    } else {
        $dataHt['IpAddress'] = $ipCache[$dataHt['SubjectLogonId']]
    }
    ...
}
$localIps = (Get-NetIPAddress).IPAddress
$report = $report | ?{$_.Share -ne '\\*\IPC$'}
$report = $report | ?{$localIps -notcontains $_.IpAddress}
$report | ConvertTo-Html | Out-File C:\tmp\Simple-file-audit-RPT.html

$pathGroup = $report | Group-Object Path | Where-Object {$_.Name}
$shareGroup = $report | Group-Object Share | Where-Object {$_.Name}
$html = html {
    header {
        h1 {
            'Share Access Report'
        }
    }
    h2 {
        'Table of contents'
    }
    li {
        'Paths'
        foreach ($pg in $pathGroup) {
            ul {
                a -href "#$($pg.Name)" {
                    $pg.Name
                }
            }
        }
    }
    li {
        'Shares'
        foreach ($sg in $shareGroup) {
            ul {
                a -href "#$($sg.Name)" {
                    $sg.Name
                }
            }
        }
    }
    foreach ($pg in $pathGroup) {
        h2 -Id $pg.Name {
            $pg.Name
        }
        $pg.Group | ConvertTo-PSHTMLTable -Properties Time,EventId,LogonId,Path,User,UserDomain,IpAddress,AccessType
    }
    foreach ($sg in $shareGroup) {
        h2 -Id $sg.Name {
            $sg.Name
        }
        $sg.Group | ConvertTo-PSHTMLTable -Properties Time,EventId,LogonId,Share,User,UserDomain,IpAddress,AccessType
    }
}
$html | Out-File C:\tmp\File-Audit-RPT.html
