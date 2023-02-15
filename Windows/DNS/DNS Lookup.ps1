# Script will prompt for the domain
# Files will be Saved to the C:\temp folder with the domain entered as the filename
$ErrorActionPreference = "silentlycontinue"
write-host "Records will be saved in the C:\temp folder with the name of the domain entered." -ForegroundColor DarkRed -BackgroundColor Yellow
$domain = read-host "Enter  Domain to Check DNS records for"
write-host " "
write-host "Getting DNS Records Please Wait" -ForegroundColor Magenta
write-host " "
Resolve-DnsName $domain -type UNKNOWN -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
resolve-DnsName $domain -type A_AAAA  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type A  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force 
Resolve-DnsName $domain -type AAAA  -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type NS -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MX -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MD -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MF -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type CNAME -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type SOA -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MB -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MG -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MR -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type NULL -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type WKS -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type PTR -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type HINFO -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type MINFO -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type TXT -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type RP -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type AFSDB -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type X25  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type ISDN  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type RT  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type SRV  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type DNAME  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type OPT  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type DS  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type RRSIG -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type NSEC  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type DNSKEY -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type DHCID -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type NSEC3  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type NSEC3PARAM  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type ANY  -ErrorAction SilentlyContinue|  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
Resolve-DnsName $domain -type ALL -ErrorAction SilentlyContinue |  export-csv -notypeinformation -Path c:\temp\$domain.csv -Append -force
write-host "DNS Record Retrieval is complete. Please check the c:\temp folder for the file" -ForegroundColor Magenta


