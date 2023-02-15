 Get-ADUser -Filter{name -like "*" -and enabled -eq $true} | select-object name,samaccountname


