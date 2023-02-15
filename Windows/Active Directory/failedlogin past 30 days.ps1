$Date= Get-date     
 
$DC= "bosa-dc01" 
 
$Report= "C:\scripts\failedlogin.html" 
 
$HTML=@" 
<title>Event Logs Report</title> 
 
 
"@ 
 
$eventsDC= Get-Eventlog security -Computer $DC -InstanceId 4625 -After (Get-Date).AddDays(-30) | 
   Select TimeGenerated,ReplacementStrings | 
   % { 
     New-Object PSObject -Property @{ 
      Source_Computer = $_.ReplacementStrings[13] 
      UserName = $_.ReplacementStrings[5] 
      IP_Address = $_.ReplacementStrings[19] 
      Date = $_.TimeGenerated 
    } 
   } 
    
  $eventsDC | ConvertTo-Html -Property Source_Computer,UserName,IP_Address,Date -head $HTML -body "<H2>Gernerated On $Date</H2>"| 
     Out-File $Report -Append 