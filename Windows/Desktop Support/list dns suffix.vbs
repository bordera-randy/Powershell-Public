Option Explicit

Dim objRootDSE, strDNSDomain, adoConnection, adoCommand, strQuery, strCompName, strSearch
Dim adoRecordset, strComputerDN, strBase, strFilter, strAttributes, objSystemInfo, objRecordSet, colServiceList, objService
Dim colNamedArguments, DNSDomain, NetConnName, strComputer, objWMIService, colItems, objItem, strMacAddress, colNetCards, objNetCard

Const FOR_READING = 1
Const ADS_SCOPE_SUBTREE = 2

'Determine NetBIOS domain
Set objSystemInfo = CREATEOBJECT("ADSystemInfo") 
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
strFilter = "(&(objectCategory=computer)(operatingSystem=*server*)(!userAccountControl:1.2.840.113556.1.4.803:=2))"


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
	strComputer = objRecordSet.Fields("Name").Value
	Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	If Err.Number = 0 Then
		Err.Clear
		Set colItems = objWMIService.ExecQuery ("Select * From Win32_NetworkAdapter")
		If (Err.Number = 0 and Not colItems.Count = 0) Then
			Err.Clear
			For Each objItem in colItems
				If (Not IsNull(objItem.NetConnectionID) And objItem.NetConnectionStatus = "2") Then
					'wscript.echo strComputer & " " & objItem.NetConnectionID & vbCrlf
					'If objItem.NetConnectionID = NetConnName Then
						call ListDnsSuffix (strMacAddress )
					'End If
				End If
			Next
		Else
			wscript.echo "Get Network Adapters Failed for " & strComputer
			'DisplayErrorInfo strComputer
			'wscript.echo vbCrlf
		End If
	Else
		wscript.echo "Computer Connection"
		DisplayErrorInfo strComputer
		wscript.echo vbCrlf
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


Sub ListDnsSuffix(strMacAddress )
	
	Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colNetCards = objWMIService.ExecQuery ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled =True")

	For Each objNetCard in colNetCards
		'ListDnsSuffix=objNetCard.DNSDomain
		wscript.echo strComputer & objNetCard.DNSDomain
	Next

	'WMIEchoStr=DNSDomain
	
End Sub