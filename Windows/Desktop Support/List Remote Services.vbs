' Michael Maher 14/6/07
' Searches all servers in nominated OU for services running under credentials of service account. 
' Useful when password needs to be reset.

' Modify Script:
'    - Your Domain Details Line 21
'    - Your Service Account Name Line 33

'On Error Resume Next

Const FOR_READING = 1
Const ADS_SCOPE_SUBTREE = 2

Set objConnection = CreateObject("ADODB.Connection")
Set objCommand =   CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider" 


Set objCommand.ActiveConnection = objConnection
objCommand.CommandText = "SELECT Name FROM 'LDAP://dc=harperdom,dc=local' WHERE objectClass='Computer' AND OperatingSystem='*server*'"
Set objRecordSet = objCommand.Execute

objRecordSet.MoveFirst

Do Until objRecordSet.EOF
   strComputer = objRecordSet.Fields("Name").Value
WScript.Echo "Name: " & strComputer 

        Set objComputer = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
        Set colServiceList = objComputer.ExecQuery _
            ("Select * from Win32_Service Where StartName = 'STB\\STBADMIN'")

        For Each objService in colServiceList
            Wscript.Echo objService.DisplayName
        Next

    objRecordSet.MoveNext
Loop
