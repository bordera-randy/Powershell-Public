<###################################################################### 
#                                                                      
# Author       : MESUT ALADAG     
# Web          : www.mesutaladag.com                                 
# Date         : 7th March 2015                                 
# Version      : 1.0                                                 
# Description  : This script will add the user accounts listed in Users file to local administrators on servers listed in servers file 
# Partner      : KOCSISTEM - mesut.aladag@kocsistem.com.tr                                                     
######################################################################> 
############################## PING STATUS CODES ##################### 
        #       0         {"Success"} 
        #   11001   {"Buffer Too Small"} 
        #   11002   {"Destination Net Unreachable"} 
        #   11003   {"Destination Host Unreachable"} 
        #   11004   {"Destination Protocol Unreachable"} 
        #   11005   {"Destination Port Unreachable"} 
        #   11006   {"No Resources"} 
        #   11007   {"Bad Option"} 
        #   11008   {"Hardware Error"} 
        #   11009   {"Packet Too Big"} 
        #   11010   {"Request Timed Out"} 
        #   11011   {"Bad Request"} 
        #   11012   {"Bad Route"} 
        #   11013   {"TimeToLive Expired Transit"} 
        #   11014   {"TimeToLive Expired Reassembly"} 
        #   11015   {"Parameter Problem"} 
        #   11016   {"Source Quench"} 
        #   11017   {"Option Too Big"} 
        #   11018   {"Bad Destination"} 
        #   11032   {"Negotiating IPSEC"} 
        #   11050   {"General Failure"} 
        #  default {"Failed"} 
############################## PING STATUS CODES #####################     
#Parametreler istege gore degistirilebilir. 
if (Test-Path "C:\Scripts\SonuclarRemove.txt") 
{ 
Remove-Item "C:\Scripts\SonuclarRemove.txt" -Force 
Write-Host "C:\Scripts\SonuclarRemove.txt found and deleted" -ForegroundColor White -BackgroundColor Red 
} 
if (Test-Path "C:\Scripts\RemoveGroupHostunreachable.txt") 
{ 
Remove-Item "C:\Scripts\RemoveGroupHostunreachable.txt" -Force 
Write-Host "C:\Scripts\RemoveGroupHostunreachable.txt found and deleted" -ForegroundColor White -BackgroundColor Red 
} 
$servers=gc "C:\Scripts\Servers.txt" 
foreach ($srv in $servers)  
{  
$starttime=get-date 
Write-Host "Starting Control for Computer $srv at $starttime `n" -ForegroundColor Cyan -BackgroundColor DarkBlue | out-default 
$pingStatus = Get-WmiObject -Query "Select * from win32_PingStatus where Address='$srv'" 
if($pingStatus.StatusCode -eq 0)  
{ 
$users=gc "C:\Scripts\users.txt" 
foreach ($usr in $users)  
{ 
Write-Host "Ping Control for Computer $srv at $starttime successfully. Now connecting PSEXEC `n" -ForegroundColor Cyan -BackgroundColor DarkBlue | out-default 
C:\Scripts\PsExec.exe \\$srv net localgroup administrators COZUMPARK\$usr /delete 
$stoptime=get-date 
$rapor="$srv;$usr removed from local admin group;$stoptime" 
Write-Host $rapor `n 
$rapor | Out-File "C:\Scripts\SonuclarRemove.txt" -Append 
} 
Write-Host "Successfully finished user remove from local admin for Computer $srv at $stoptime `n" -ForegroundColor Cyan -BackgroundColor DarkBlue | out-default 
} 
else { 
Write-Host "Ping Control for Computer $srv at $starttime failed. `n" -ForegroundColor Cyan -BackgroundColor DarkBlue | out-default 
$srv | Out-File "C:\Scripts\RemoveGroupHostunreachable.txt" -Append 
} 
if (Test-Path "C:\Scripts\SonuclarRemove.txt") 
{ 
$sonuc=gc "C:\Scripts\SonuclarRemove.txt" 
Write-Host "#########################  SUCCESSFULLY CONNECTED AND USER REMOVED FROM LOCAL ADMINISTRATORS GROUP SYSTEMS  #################################" 
Write-Host "======================================================================================================================" 
foreach ($item in $sonuc)  
{  
Write-Host $item 
} 
} 
if (Test-Path "C:\Scripts\RemoveGroupHostunreachable.txt") 
{ 
$sonuc1=gc "C:\Scripts\RemoveGroupHostunreachable.txt" 
Write-Host "#########################  CONNECTION FAILED SYSTEMS  #################################" 
Write-Host "======================================================================================================================" 
foreach ($item1 in $sonuc1)  
{  
Write-Host $item1 
} 
} 
}