
$testzonename = 'test'

$zones = Get-DnsServerZone | Where-Object Zonename -like $testzonename*
foreach ($item in $zones) {
    write-host -ForegroundColor Yellow "Removing Zone" $item.ZoneName
    Remove-DnsServerZone -Name $item.zonename -Force
}

