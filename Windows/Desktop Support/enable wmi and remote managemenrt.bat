netsh advfirewall set domainprofile settings remotemanagement enable
netsh advfirewall show domainprofile
netsh advfirewall firewall set rule group="Windows Management Instrumentation (WMI)" new enable=yes
netsh advfirewall set domainprofile state off