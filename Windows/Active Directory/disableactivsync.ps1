# To Connect to Exchange
#Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

# To disable Active sync on a mailbox

set-casmailbox -identity "sact calendar" -activesyncenabled $false
set-casmailbox -identity "arm calendar" -activesyncenabled $false
set-casmailbox -identity "bankers toolbox" -activesyncenabled $false
set-casmailbox -identity "tm sales" -activesyncenabled $false
set-casmailbox -identity "operations" -activesyncenabled $false
set-casmailbox -identity "investments" -activesyncenabled $false


