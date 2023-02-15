Import-Module ActiveDirectory
$users = Get-ADUser -Filter *
foreach ($user in $users)
{
$email = $user.samaccountname + '@domainName.com'
$newemail = "SMTP:"+$email
Set-ADUser $user -Add @{proxyAddresses = ($newemail)}
}