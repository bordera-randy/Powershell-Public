get-AutodiscoverVirtualDirectory | select-object server,internalurl, externalurl | fl
get-ClientAccessServer | select-object name,AutodiscoverServiceInternalUri | fl
get-webservicesvirtualdirectory | select-object server,internalurl, externalurl | fl
get-oabvirtualdirectory | select-object server,internalurl, externalurl | fl
get-owavirtualdirectory | select-object server,internalurl, externalurl | fl
get-ecpvirtualdirectory | select-object server,internalurl, externalurl | fl
get-ActiveSyncVirtualDirectory | select-object server,internalurl, externalurl | fl


$urlpath = Read-Host "Type internal Client Access FQDN starting with http:// or https://"

Set-ClientAccessServer -Identity * -AutodiscoverServiceInternalUri $urlpath/autodiscover/autodiscover.xml
Set-webservicesvirtualdirectory -Identity * -internalurl $urlpath/ews/exchange.asmx
Set-oabvirtualdirectory -Identity * -internalurl $urlpath/oab
Set-owavirtualdirectory -Identity * -internalurl $urlpath/owa
Set-ecpvirtualdirectory -Identity * -internalurl $urlpath/ecp
Set-ActiveSyncVirtualDirectory -Identity * -InternalUrl "$urlpath/Microsoft-Server-ActiveSync"

Set-webservicesvirtualdirectory -Identity * -ExternalUrl $urlpath/ews/exchange.asmx
Set-oabvirtualdirectory -Identity * -ExternalUrl $urlpath/oab
Set-owavirtualdirectory -Identity * -ExternalUrl $urlpath/owa
Set-ecpvirtualdirectory -Identity * -ExternalUrl $urlpath/ecp
Set-ActiveSyncVirtualDirectory -Identity * -ExternalUrl "$urlpath/Microsoft-Server-ActiveSync"