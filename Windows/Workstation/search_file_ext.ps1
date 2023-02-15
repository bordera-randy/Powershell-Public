$path = "e:\shared\apps\adjutant\"
$ext = *.bak 
get-childitem $Path -recurse | where {$_.extension -eq $ext} | format-table  
