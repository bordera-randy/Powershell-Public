' Modify Script:
'    - Your Server OU  Line 11 
'    - Your Domain Details Line 23
'    - Your Service Account Name Line 33
On Error Resume Next
strOu="Servers"
Const FOR_READING = 1
Const ADS_SCOPE_SUBTREE = 2
Set objConnection = CreateObject("ADODB.Connection")
Set objCommand =   CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider" 

Set objCommand.ActiveConnection = objConnection
objCommand.CommandText = "SELECT Name FROM 'LDAP://Ou=" & strOU & _
    ",OU=CBHSystems,DC=central-nt,DC=local' WHERE objectClass='Computer'"   
Set objRecordSet = objCommand.Execute
objRecordSet.MoveFirst
Do Until objRecordSet.EOF
   strComputer = objRecordSet.Fields("Name").Value
WScript.Echo vbCrLf & "Name: " & strComputer 
        Set objComputer = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
        Set colServiceList = objComputer.ExecQuery ("Select * from Win32_Service Where StartName LIKE 'CENTRAL-NT%' OR StartName LIKE '%@central-nt%'")
        For Each objService in colServiceList
            Wscript.Echo vbTab & objService.DisplayName
        Next
    objRecordSet.MoveNext
Loop
