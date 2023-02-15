Get-ADUser -Filter * -SearchBase "DC=BOFSA,DC=LOCAL" |  ft -autosize -wrap -property name, samaccountname, {$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))} -GroupBy {$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))}



Get-ADUser -Filter * |  ForEach-Object { 
    $DN = $_.distinguishedname -split ',' 
    $container = $DN[1..($DN.count -1)] -join ','
    Write-Host $_.name,";"$_.samaccountname,";"$container
    }

Get-ADUser -Filter * -SearchBase "DC=BOFSA,DC=LOCAL" |  select-object name, samaccountname, @{Name = 'OU'; Expression={$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))}} | Sort-Object OU | export-csv C:\scripts\RPTS\adusers.csv