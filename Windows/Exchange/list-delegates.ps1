[Array]$resourcedelegates=$null
$users = get-mailbox -ResultSize unlimited
Foreach ($user in $users){
	$Delegates = (get-mailbox $user | Get-CalendarProcessing).resourcedelegates
	$i=0
	do {$Delegate=$Delegates[$i].Name
		$i++
		if($Delegate)
			{$resourcedelegates += New-Object Psobject -Property @{"UserName"=$user;"Delegate Name"=$Delegate}
			#Write-host $User $Delegate
			}
		}Until ($Delegate -eq $Null)
	}
$resourcedelegates | Export-Csv c:\temp\delegates.csv -NoTypeInformation