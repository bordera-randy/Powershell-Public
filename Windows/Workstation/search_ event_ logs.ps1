Get-WinEvent -computer sat-bernanke -FilterHashtable @{logname='security';data='pgold'} | ft -AutoSize -wrap


