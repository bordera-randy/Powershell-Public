function Get-PathPermissions {

    param ( [Parameter(Mandatory=$true)] [System.String]${Path}	)

    begin {
    $root = Get-Item -LiteralPath $Path
    (Get-Item -LiteralPath $root).GetAccessControl().Access | Add-Member -MemberType NoteProperty -Name "Path" -Value $($root.fullname).ToString() -PassThru -Force
    }

    process {
        $containers = Get-ChildItem -path $Path -recurse | ? {$_.psIscontainer -eq $true}
        if ($containers -eq $null) {break}
        foreach ($container in $containers)
        {
        (Get-Item -LiteralPath $container.fullname).GetAccessControl().Access | ? { $_.IsInherited -eq $false } | Add-Member -MemberType NoteProperty -Name "Path" -Value $($container.fullname).ToString() -PassThru -Force
        }
    }
}

$Drives = GET-WMIOBJECT –query “SELECT * from win32_logicaldisk where DriveType = 3” | ForEach-Object {$_.DeviceID}

foreach ($Drive in $Drives) {
	Get-PathPermissions $Drive\ | Select-Object *,@{Name='Server';Expression={$env:COMPUTERNAME}} | ft -autosize
	}