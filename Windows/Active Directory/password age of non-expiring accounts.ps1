##################################################################################################################
#Password Age
###################################################################################################################
$obj = @()
$UserDetails = @()

#Get Users From AD who are enabled
Import-Module ActiveDirectory
$users = get-aduser -filter * -properties * |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $true }

foreach ($user in $users)
    {
        
        $Name = (Get-ADUser $user | foreach { $_.Name})
        $passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })
        
        #Create custom object
                                $obj = New-Object PSobject
                                $obj | Add-Member -MemberType NoteProperty -name "Name" -value $Name
                                $obj | Add-Member -MemberType NoteProperty -name "Password Last Set" -value $passwordSetDate
                                #Add user object to array for output
                                $UserDetails += $obj
    }


return $UserDetails | out-file -FilePath C:\users\sa.managediron\desktop\Passwordset.txt
