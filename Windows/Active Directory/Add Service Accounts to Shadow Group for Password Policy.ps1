$OU="OU=Service Accounts,OU=Users,OU=BOSA,DC=bofsa,DC=local"
$ShadowGroup="CN=Service Accounts Password Policy,OU=Security Groups,OU=BOSA,DC=bofsa,DC=local"
Get-ADGroupMember –Identity $ShadowGroup | Where-Object {$_.distinguishedName –NotMatch $OU} | ForEach-Object {Remove-ADPrincipalGroupMembership –Identity $_ –MemberOf $ShadowGroup –Confirm:$false}
Get-ADUser –SearchBase $OU -SearchScope Subtree –LDAPFilter "(!memberOf=$ShadowGroup)" | ForEach-Object {Add-ADPrincipalGroupMembership –Identity $_ –MemberOf $ShadowGroup}