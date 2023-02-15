

Connect-AzAccount

$subscriptions = Get-AzSubscription 
$perms = foreach ($Item in $subscriptions) {
    Get-AzRoleAssignment | select-object DisplayName, objectid, RoleDefinitionName, ObjectType, Scope | Where-Object ObjectType -NE "ServicePrincipal"
    }
 
$perms | export-csv -NoTypeInformation -path c:\az\permissions.csv
