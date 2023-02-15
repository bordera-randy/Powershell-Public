# Variables
$password = "Password1" |convertto-securestring -asplaintext -force
$ErrorActionPreference = 'silentlycontinue'

If (get-localuser -name testlocal3){
    set-localuser -name testlocal3 -Password $password
    }
    Else {
#Local Account Creation
Try { 
	new-localuser -name testlocal3 -password $password  -description "Test account local" -erroraction stop
    Add-LocalGroupMember -Group "Administrators" -Member "testlocal3"
    }

Catch 
	{ 
	$_.exception | out-file c:\temp\log.txt
    }
                                }