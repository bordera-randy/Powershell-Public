
$tenantid = '10059976a'
$infraenvironment = 'DEV'
$region = 'UNC'
$zonename = 'duckcreekondemand.com'


        $claimswebbackend           = $($infraenvironment  + '-' + 'clms01a'                + '-' + $region + '-ase01.' + $zonename)
        $claimsapibackend           = $($infraenvironment  + '-' + 'clmsapi01a'             + '-' + $region + '-ase01.' + $zonename)
        $coreapisbackend            = $($infraenvironment  + '-' + 'core01a'                + '-' + $region + '-ase01.' + $zonename)
        $dashboardbackend           = $($infraenvironment  + '-' + 'dashboard01a'           + '-' + $region + '-ase01.' + $zonename)
        $refdatabackend             = $($infraenvironment  + '-' + 'refdt01a'               + '-' + $region + '-ase01.' + $zonename)
        $claimscmtoolbackend        = $($infraenvironment  + '-' + 'cfgmgmt01a'             + '-' + $region + '-ase01.' + $zonename)
        $partycmtoolbackend         = $($infraenvironment  + '-' + 'pcfgmgmt01a'            + '-' + $region + '-ase01.' + $zonename)
        $claimsstudiobackend        = $($infraenvironment  + '-' + 'clmcnsls01a'            + '-' + $region + '-ase01.' + $zonename)
        $partystudiobackend         = $($infraenvironment  + '-' + 'prtycnsls01a'           + '-' + $region + '-ase01.' + $zonename)
        $amibackend                 = $($infraenvironment  + '-' + 'ami01a'                 + '-' + $region + '-ase01.' + $zonename)
        $authbackend                = $($infraenvironment  + '-' + 'auth01a'                + '-' + $region + '-ase01.' + $zonename)
        $claimsbulkloadapibackend   = $($infraenvironment  + '-' + 'clmcbulkapi01a'         + '-' + $region + '-ase01.' + $zonename)
        $partybulkloadapibackend    = $($infraenvironment  + '-' + 'prtycbulkapi01a'        + '-' + $region + '-ase01.' + $zonename)
        $metasearchbackend          = $($infraenvironment  + '-' + 'metasearch01a'          + '-' + $region + '-ase01.' + $zonename)
        $claimsentityclonerbackend  = $($infraenvironment  + '-' + 'aclaimsentitycloner'    + '-' + $region + '-ase01.' + $zonename)
        $claimsmigrationapibackend  = $($infraenvironment  + '-' + 'aclaimsmigrapi'         + '-' + $region + '-ase01.' + $zonename)
        $claimsmigrationapibackend  = $($infraenvironment  + '-' + 'clmsmigration01a'       + '-' + $region + '-ase01.' + $zonename)
        $partybackend               = $($infraenvironment  + '-' + 'prty01a'                + '-' + $region + '-ase01.' + $zonename)

Write-Host -ForegroundColor Yellow "Creating cName records for $tenantid"
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'clms01a'                + '-' + $region + '-ase01') -HostNameAlias $claimswebbackend            -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'clmsapi01a'             + '-' + $region + '-ase01') -HostNameAlias $claimsapibackend            -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'core01a'                + '-' + $region + '-ase01') -HostNameAlias $coreapisbackend             -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'dashboard01a'           + '-' + $region + '-ase01') -HostNameAlias $dashboardbackend            -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'refdt01a'               + '-' + $region + '-ase01') -HostNameAlias $refdatabackend              -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'cfgmgmt01a'             + '-' + $region + '-ase01') -HostNameAlias $claimscmtoolbackend         -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'pcfgmgmt01a'            + '-' + $region + '-ase01') -HostNameAlias $partycmtoolbackend          -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'clmcnsls01a'            + '-' + $region + '-ase01') -HostNameAlias $claimsstudiobackend         -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'prtycnsls01a'           + '-' + $region + '-ase01') -HostNameAlias $partystudiobackend          -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'ami01a'                 + '-' + $region + '-ase01') -HostNameAlias $amibackend                  -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'auth01a'                + '-' + $region + '-ase01') -HostNameAlias $authbackend                 -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'clmsmigration01a'       + '-' + $region + '-ase01') -HostNameAlias $claimsmigrationapibackend   -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'clmcbulkapi01a'         + '-' + $region + '-ase01') -HostNameAlias $claimsbulkloadapibackend    -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'prtycbulkapi01a'        + '-' + $region + '-ase01') -HostNameAlias $partybulkloadapibackend     -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'metasearch-01a'         + '-' + $region + '-ase01') -HostNameAlias $metasearchbackend           -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'prty01a'                + '-' + $region + '-ase01') -HostNameAlias $partybackend                -ZoneName $zonename    
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'aclaimsentitycloner')                               -HostNameAlias $claimsentityclonerbackend   -ZoneName $zonename
        Add-DnsServerResourceRecordCName -Name $($tenantid + '-' + 'aclaimsmigrapi')                                    -HostNameAlias $claimsmigrationapibackend   -ZoneName $zonename
        