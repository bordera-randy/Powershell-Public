Import-Module ActiveDirectory

$Groups = (Get-AdGroup -filter * | Where {($_.name -notlike "Domain Computers") -and ($_.name -like "**")}) #| select name -ExpandProperty name)

$Table = @()

$Record = @{
  "Group Name" = ""
  "Name" = ""
  "Username" = ""
}


Foreach ($Group in $Groups) {

  $Arrayofmembers = Get-ADGroupMember -identity $Group.DistinguishedName -recursive | select name,samaccountname

  foreach ($Member in $Arrayofmembers) {
    $Record."Group Name" = $Group.name
    $Record."Name" = $Member.name
    $Record."UserName" = $Member.samaccountname
    $objRecord = New-Object PSObject -property $Record
    $Table += $objrecord

  }
}

$Table | export-csv ".\SecurityGroups.csv" -NoTypeInformation

***************************************************************************************************************************
Clear-Host
$groups = Get-ADGroup -filter *
$output = ForEach ($g in $groups) 
 {
 $results = Get-ADGroupMember -Identity $g.name -Recursive | Get-ADobject -Properties displayname, objectclass, name 

 ForEach ($r in $results){
 New-Object PSObject -Property @{
        GroupName = $g.Name
        Username = $r.name
        ObjectClass = $r.objectclass
        DisplayName = $r.displayname
     }
    }
 } 
 $output | Export-Csv -path .\groupsout.csv