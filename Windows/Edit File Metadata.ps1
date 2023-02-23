
$file = 'C:\az\file_example_MP4_480_1_5MG.mp4' 

# The index of the property to retrieve.
$propIndex = 24  # Comments

$folder = (New-Object -ComObject Shell.Application).NameSpace((Split-Path $file))

# Output the value of the "Comments" property.
$folder.GetDetailsOf(
  $folder.ParseName((Split-Path -Leaf $file)),
  24
)

$names = @()
$folder = (New-Object -ComObject Shell.Application).NameSpace("$pwd")
# Note: Assumes that no indices higher than 1000 exist.
0..27 | ForEach-Object { 
  if ($n = $folder.GetDetailsOf($null, $_)) { 
    [pscustomobject] @{ Index = $_; Name = $n } 
    
    $names += $n
  } 
}



$myFileObj = Get-Item -Path "C:\az\file_example_MP4_480_1_5MG.mp4"
$shellCom = New-Object -ComObject Shell.Application
$sDirectory = $shellCom.NameSpace($myFileObj.Directory.FullName)
$sFile = $sDirectory.ParseName($myFileObj.Name)
