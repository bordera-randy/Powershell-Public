Get-ADUser -Filter * -SearchBase "DC=BOFSA,DC=LOCAL" |  select-object name, samaccountname, @{Name = 'OU'; Expression={$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))}} | Sort-Object OU | export-csv c:\support\test.csv


***** OLD *****


Get-ADUser -Filter * -SearchBase "DC=BOFSA,DC=LOCAL" |  ft -autosize -wrap -property name, samaccountname, {$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))} -GroupBy {$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))}

Get-ADUser -Filter * -SearchBase "DC=BOFSA,DC=LOCAL" |  select-object name, samaccountname, {$_.distinguishedname.substring($_.distinguishedname.IndexOf("OU="))} | export-csv c:\support\test.csv