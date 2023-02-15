repadmin /showrepl * /csv >>c:\temp\showrepl.csv
repadmin /showrepl * >>c:\temp\showrepl.txt
repadmin /showreps >> c:\temp\showreps.txt
DCDAIG /TEST:CheckSecurityError >> c:\temp\checksecurityerror.txt
NETDIAG >> c:\temp\netdiag.txt
reg query HKLM\Software\Policies\Microsoft\Windows NT\RPC /v RestrictRemoteClients >> c:\temp\RestrictRemoteClients.txt
reg query HKLM\System\CurrentControlSet\Control\LSA /v CrashOnAuditFail  >> c:\temp\crashonauditfail.txt

