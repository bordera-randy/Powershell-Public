Import-Module grouppolicy
$date = get-date -format M.d.yyyy-HH.mm.ss
New-Item -Path c:\support\GPBackup\$date -ItemType directory
sleep 10
get-gporeport -All -ReportType Html -Path c:\support\GPBackup\$date