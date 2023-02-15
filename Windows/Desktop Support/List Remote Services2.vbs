' Michael Maher 14/6/07
' Searches all servers in nominated OU for services running under credentials of service account. 
' Useful when password needs to be reset.

' Modify Script:
'    - Your Domain Details Line 21
'    - Your Service Account Name Line 33

On Error Resume Next

Const FOR_READING = 1
Const ADS_SCOPE_SUBTREE = 2

Set objConnection = CreateObject("ADODB.Connection")
Set objCommand =   CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider" 


Set objCommand.ActiveConnection = objConnection
objCommand.CommandText = "SELECT Name FROM 'LDAP://DC=triconenergy,DC=com' WHERE objectClass='Computer' AND OperatingSystem ='*server*'"

Set objRecordSet = objCommand.Execute

objRecordSet.MoveFirst

Err.Clear

Do Until objRecordSet.EOF
	'wscript.echo "enter do-until"
	
	strComputer = objRecordSet.Fields("Name").Value
	Set objComputer = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	
	
	If objComputer.AccountDisabled = False Then
		WScript.echo 
		WScript.Echo "Name: " & strComputer
		If Err.Number <> 0 Then
			Wscript.Echo vbtab & "Error: " & Err.Number
			Wscript.Echo vbtab & "Error (Hex): " & Hex(Err.Number)
			Wscript.Echo vbtab & "Source: " &  Err.Source
			Wscript.Echo vbtab & "Description: " &  Err.Description
			Err.Clear
		End If

		Set colServiceList = objComputer.ExecQuery ("Select * from Win32_Service  Where StartName LIKE '%robot%'")

		For Each objService in colServiceList
			Wscript.Echo vbTab & objService.DisplayName
			'wscript.echo "entered objserv print at btm"
		Next
	End If
	Set objService = Nothing
	Set colServiceList = Nothing
	Set objComputer = Nothing

	objRecordSet.MoveNext
Loop