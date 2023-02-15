Function Convert-ImmutableID (
    [Parameter(Mandatory = $true)]
    $ImmutableID) { 
    ([GUID][System.Convert]::FromBase64String($ImmutableID)).Guid
}
Function Convert-ObjectGUID (
    [Parameter(Mandatory = $true)]
    $ObjectGUID) { 
    [system.convert]::ToBase64String(([GUID]$ObjectGUID).ToByteArray())
}
Convert-ImmutableID -ImmutableID 'h9RUd8MfBkKelc4BLxWG5Q=='
Convert-ObjectGUID -objectGUID '7754d487-1fc3-4206-9e95-ce012f1586e5'