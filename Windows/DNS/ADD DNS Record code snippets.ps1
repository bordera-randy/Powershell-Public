Add-DnsServerResourceRecordA -Name reddeerprint01 -ZoneName corp.ad -IPv4Address 192.168.2.56

Add-DnsServerResourceRecordAAAA -Name it-intranet -ZoneName corp.ad -IPv6Address "fc00::0128"
Add-DnsServerPrimaryZone -ComputerName DC03 -NetworkId "192.168.2.0/24" -ReplicationScope Forest

Add-DnsServerResourceRecordCName -ZoneName corp.ad -HostNameAlias "webapp25.corp.ad" -Name "finance"



#You can create a Reverse Lookup Zone:
Add-DnsServerPrimaryZone -NetworkId "192.168.100.0/24" -ReplicationScope Domain

#To synchronize a new zone with other DCs in the domain, run the following command:
Sync-DnsServerZone –passthru

#Display the list of records in the new DNS zone (it is empty):
Get-DnsServerResourceRecord -ComputerName dc01 -ZoneName contoso.local

#To create a new A record for the host in the specified DNS zone, use this command:
Add-DnsServerResourceRecordA -Name ber-rds1 -IPv4Address 192.168.100.33 -ZoneName woshub.com -TimeToLive 01:00:00

#To add a PTR record to the Reverse Lookup Zone, you can add –CreatePtr parameter to the previous command or create the pointer manually using the Add-DNSServerResourceRecordPTR cmdlet:
Add-DNSServerResourceRecordPTR -ZoneName 100.168.192.in-addr.arpa -Name 33 -PTRDomainName ber-rds1.woshub.com

#To add an alias (CNAME) for the specific A record, run this command:
Add-DnsServerResourceRecordCName -ZoneName woshub.com -Name Ber-RDSFarm -HostNameAlias ber-rds1.woshub.com

#To change (update) the IP address in the A record, you will have to apply quite a complex method since you cannot change an IP address of a DNS record directly:
$NewADNS = get-DnsServerResourceRecord -Name ber-rds1 -ZoneName woshub.com -ComputerName dc01
$OldADNS = get-DnsServerResourceRecord -Name ber-rds1 -ZoneName woshub.com -ComputerName dc01

#Then change the IPV4Address property of the $NewADNS object:
$NewADNS.RecordData.IPv4Address = [System.Net.IPAddress]::parse('192.168.100.133')

#Change the IP address of the A record using the Set-DnsServerResourceRecord cmdlet:
Set-DnsServerResourceRecord -NewInputObject $NewADNS -OldInputObject $OldADNS -ZoneName woshub.com -ComputerName dc01

#Make sure that the IP address of the A record has changed:
Get-DnsServerResourceRecord -Name ber-rds1 -ZoneName woshub.com