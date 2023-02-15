$Users = Import-Csv -Delimiter "," -Path "xpusers.csv"
foreach ($User in $Users)            
{            
    $Displayname = $User.name # + " " + $User.Lastname
    $Username = $User.name
    #$UserLastname = $User.Lastname
    #$OU = "$User.OU"
    #$SAM = $User.name
    $UPN = $User.name + "@thebankofaustin.com" #+ $User.Maildomain # + "." + $User.Lastname
    $Description = $User.Description
    $Password = $User.Password
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName "$Displayname" -UserPrincipalName $UPN -GivenName "$Username"  -Description "$Description" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false –PasswordNeverExpires $true -server boa-colo-dc01
}