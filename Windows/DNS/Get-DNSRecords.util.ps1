# From the DNS Server
$Zones = @(Get-DnsServerZone)
ForEach ($Zone in $Zones) {
	Write-Host "`n$($Zone.ZoneName)" -ForegroundColor "Green"
	$Zone | Get-DnsServerResourceRecord
}


# From a Remote DNS Server
$DNSServer = "servernameOrIp"
$Zones = @(Get-DnsServerZone -ComputerName $DNSServer)
ForEach ($Zone in $Zones) {
	Write-Host "`n$($Zone.ZoneName)" -ForegroundColor "Green"
	$Zone | Get-DnsServerResourceRecord -ComputerName $DNSServer
}



# From a Remote DNS Server (Output to Tab Delimited File)
$DNSServer = "UNCPRD01CMN01"
$date = Get-Date -Format "MM-dd-yyyy" -DisplayHint Date
$folder = "c:\DNSRecords\$date-$dnsserver"
mkdir -Path $folder -ErrorAction SilentlyContinue

$Zones = @(Get-DnsServerZone -ComputerName $DNSServer)
ForEach ($Zone in $Zones) {
	Write-Host "`n$($Zone.ZoneName)" -ForegroundColor "Green"
	$Results = $Zone | Get-DnsServerResourceRecord -ComputerName $DNSServer
	echo $Results > "$folder\$($Zone.ZoneName).txt"
}



## Advanced Example - HashTable ##
$Results = @()
$Zones = Get-DnsServerZone
ForEach($item in $zones)
{
 $Results += [PSCustomObject] @{
 ZoneName = $($Item.zonename)
 Hostname = $($(Get-DnsServerResourceRecord -ZoneName $($item.zonename) -RRType A | Select Hostname)).Hostname
 RecordType = $($(Get-DnsServerResourceRecord -ZoneName $($item.zonename) -RRType A | Select RecordType)).RecordType
 RecordData = $($(Get-DnsServerResourceRecord -ZoneName $($item.zonename) -RRType A | Select Hostname -ExpandProperty RecordData)).IPv4Address.IPAddressToString
 IpAddress = $($(Get-DnsServerResourceRecord -ZoneName $($item.zonename) -RRType A | Select Hostname -ExpandProperty RecordData)).IPv4Address.IPAddressToString
 Cname     = $($(Get-DnsServerResourceRecord -ZoneName $($item.zonename) -RRType CNAME | Select Hostname -ExpandProperty RecordData)).HostNameAlias
}#EndCustomObject
}#EndForEach
$Results | export-csv -NoTypeInformation -Path 'c:\temp\dnsrecords.csv'
