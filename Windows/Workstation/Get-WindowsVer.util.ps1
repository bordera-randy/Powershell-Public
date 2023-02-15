Get-ChildItem -Path 'hklm\software\microsoft\windows nt\currentversion\productname'


cd hklm
Get-ChildItem -Path 'hklm\software\microsoft\windows nt\currentversion\profileguid'

$productname = Get-ItemProperty -Path  "hklm:\\software\microsoft\windows nt\currentversion\profileguid"



$productname = Get-ChildItem -Path  "hklm:\\software\microsoft\windows nt\currentversion\productname"

$productname.Property
$productname.PSPath
$productname.PSParentPath
$productname.PSChildName
$productname.PSDrive
$productname.PSProvider
$productname.PSIsContainer
$productname.SubKeyCount
$productname.View
$productname.Handle
$productname.ValueCount
$productname.Name

