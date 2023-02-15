get-gporeport -all -ReportType Html -path "c:\temp\$($_.DisplayName).html"


**** OLD ****
get-gpo -All | foreach{ get-gporeport -guid $_.Id -ReportType Html -path "c:\users\sa.managediron\desktop\$($_.DisplayName).html"}