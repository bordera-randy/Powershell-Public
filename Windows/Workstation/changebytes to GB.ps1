Get-CimInstance Win32_LogicalDisk -filter "Deviceid='c:'" |
# change bytes to GB 
 select @{n='freegb';e={$_.freespace /1gb -as [int] }}
