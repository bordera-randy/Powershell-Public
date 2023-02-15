param(
    [ValidateSet("ExtraSuper","Normal")]
    [string]$Mode = 'Normal'
)  

$Root = [ADSI]"LDAP://RootDSE"
$DomainControllers = Get-ADDomainController -Filter *
ForEach ($DC in $DomainControllers.Name) {
    Write-Host "Processing for "$DC -ForegroundColor Green
    If ($Mode -eq "ExtraSuper") { 
        REPADMIN /kcc $DC
        REPADMIN /syncall /A /e /q $DC
    }
    Else {
        REPADMIN /syncall $DC $Root.rootDomainNamingContext /d /e /q
    }
}