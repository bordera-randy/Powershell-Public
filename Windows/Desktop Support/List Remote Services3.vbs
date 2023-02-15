' Michael Maher 14/6/07
' Searches all servers in nominated OU for services running under credentials of service account. 
' Useful when password needs to be reset.

' Modify Script:
'    - Your Domain Details Line 21
'    - Your Service Account Name Line 33

Option Explicit

Dim objRootDSE, strDNSDomain, adoConnection, adoCommand, strQuery, strComputer, strCompName, strSearch
Dim adoRecordset, strComputerDN, strBase, strFilter, strAttributes, objSystemInfo, objRecordSet, objComputer, colServiceList, objService

Const FOR_READING = 1
Const ADS_SCOPE_SUBTREE = 2

'Determine NetBIOS domain
SET objSystemInfo = CREATEOBJECT("ADSystemInfo") 
'wscript.echo objSystemInfo.DomainShortName

' Determine DNS domain name from RootDSE object.
Set objRootDSE = GetObject("LDAP://RootDSE")
strDNSDomain = objRootDSE.Get("defaultNamingContext")

' Use ADO to search Active Directory for all computers.
Set adoCommand = CreateObject("ADODB.Command")
Set adoConnection = CreateObject("ADODB.Connection")
adoConnection.Provider = "ADsDSOObject"
adoConnection.Open "Active Directory Provider"
adoCommand.ActiveConnection = adoConnection

' Search entire domain.
strBase = "<LDAP://" & strDNSDomain & ">"

' Filter on computer objects with server operating system.
strFilter = "(&(objectCategory=computer)(!operatingSystem=*server*)(!userAccountControl:1.2.840.113556.1.4.803:=2))"
'strFilter = "(&(objectCategory=computer)(!userAccountControl:1.2.840.113556.1.4.803:=2))"

' Comma delimited list of attribute values to retrieve.
strAttributes = "Name"

' Construct the LDAP syntax query.
strQuery = strBase & ";" & strFilter & ";" & strAttributes & ";subtree"



adoCommand.CommandText = strQuery
'adoCommand.Properties("Page Size") = 100
'adoCommand.Properties("Timeout") = 30
'adoCommand.Properties("Cache Results") = False

Set objRecordset = adoCommand.Execute

On Error Resume Next
	
Do Until objRecordSet.EOF
	
	strSearch = "'" & objSystemInfo.DomainShortName & "%'"
	strComputer = objRecordSet.Fields("name").Value
	Set objComputer = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	If Err.Number = 0 Then
		Set colServiceList = objComputer.ExecQuery ("Select * from Win32_Service Where StartName LIKE '%sa.managediron%'")
			'If Err = 0 Then
				WScript.Echo "Name: " , strComputer , " " , colServiceList.count
				For Each objService in colServiceList
					WScript.Echo vbTab & objService.DisplayName & " " & objService.StartName & " " & objService.StartMode
				Next
			'Else
			'	DisplayErrorInfo strComputer
			'End If
	Else
		'DisplayErrorInfo strComputer
	End If
	objRecordSet.MoveNext
Loop

Sub DisplayErrorInfo(strCompName)

	'WScript.Echo "Error:      : " & Err
	'WScript.Echo "Error (hex) : &H" & Hex(Err)
	'WScript.Echo "Source      : " & Err.Source
	WScript.Echo strCompName & " : " & Err.Description
	Err.Clear

End Sub