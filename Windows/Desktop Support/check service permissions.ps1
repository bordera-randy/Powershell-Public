
$services = get-wmiobject -query 'select * from win32_service'
foreach ($service in $services) {
    $path=$Service.Pathname
    if (-not( test-path $path -ea silentlycontinue)) {
        if ($Service.Pathname -match "(\""([^\""]+)\"")|((^[^\s]+)\s)|(^[^\s]+$)") {
            $path = $matches[0] –replace """",""
        }
    }
    if (test-path "$path") {
        $ServiceName = $service.Displayname
        $secure=get-acl $path
        foreach ($item in $secure.Access) {
            if ( ($item.IdentityReference -match "NT AUTHORITY\\SYSTEM"   ) -or
                 ($item.IdentityReference -match "NT AUTHORITY\\NETWORK"  ) -or
                 ($item.IdentityReference -match "BUILTIN\\Administrators") -or
                 ($item.IdentityReference -match "BUILTIN\\Power Users"   ) ) {
            } else {         
                if ($item.FileSystemRights.tostring() -match "Modify|Full|Change") {
                    Write "$ServiceName : Potentially Elevated Service Permission(s)"
                    Write ("   "+$item.IdentityReference.value + " : "+$item.AccessControlType.tostring() + " : "+$item.FileSystemRights.tostring())
                }
            }
        }
    } else {
            Write ("Service Path Not Found:    "+$service.Displayname)
            Write ("   "+$Path)
    }
}