function AddAuditToFile {
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$path
    )

    Get-Acl $path -Audit | Format-List Path,AuditToString | Out-File -FilePath 'file_before.txt' -Width 200 -Append
    $File_ACL = Get-Acl $path
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule("Everyone","CreateFiles”,"none","none",”Success")
    $File_ACL.AddAuditRule($AccessRule)
    $File_ACL | Set-Acl $path
    Get-Acl $path -Audit | Format-List Path,AuditToString | Out-File -FilePath 'file_after.txt' -Width 200 -Append
}

function AddAuditToRegKey {
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$key
    )

    Get-Acl $key -Audit | Format-List Path,AuditToString | Out-File -FilePath 'reg_before.txt' -Width 200 -Append
    $RegKey_ACL = Get-Acl $key
    $AccessRule = New-Object System.Security.AccessControl.RegistryAuditRule("Everyone","SetValue,CreateSubKey,Delete”,"none","none",”Success")
    $RegKey_ACL.AddAuditRule($AccessRule)
    $RegKey_ACL | Set-Acl $key
    Get-Acl $key -Audit | Format-List Path,AuditToString | Out-File -FilePath 'reg_after.txt' -Width 200 -Append
}
