#####################################
#  Name:         Get-aclaccess 
#  Date:         3/30/2020
#  Description:  This will get all the ACL's for the path you specify and export to a csv file. The file will be outputted to c:\temp\
#  Example:      Get-AclAccess "\\Server\Share"
#####################################



function Get-AclAccess {
param ($folder='.', $outfile='aces.csv')

   dir $folder -recurse |where{$_.PSIsContainer}|
   foreach {get-acl $_.pspath}|foreach {
       $Path=$_.pspath
       $_.access|where {$_.IsInherited -eq $False}|
       add-member -MemberType noteproperty -name path -value $path -passthru
   } |   export-csv c:\temp\$outfile
} 

foreach 