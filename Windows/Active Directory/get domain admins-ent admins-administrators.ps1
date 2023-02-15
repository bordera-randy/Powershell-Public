Get-ADGroupMember "Domain Admins" | select name > domainAdmins.txt
Get-ADGroupMember "Administrators" | select name >> Admins.txt
Get-ADGroupMember "Enterprise Admins" | select name >> enterpriseAdmins.txt
