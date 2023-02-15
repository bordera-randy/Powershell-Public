' Searches all servers in nominated OU for services running under credentials of service account. 
' Useful when password needs to be reset.

' Modify Script:
'    - Your Service Account Name Line 61

Option Explicit

Dim strDNSDomain, strComputer, strCompName, strSearch
Dim adoRecordset, strComputerDN, objRecordSet, objComputer, colServiceList, objService

Const FOR_READING = 1
Const ADS_SCOPE_SUBTREE = 2

strComputer = "."

On Error Resume Next
	
Set colServiceList = objComputer.ExecQuery ("Select * from Win32_Service Where StartName NOT LIKE '%localservice%' AND StartName NOT LIKE '%networkservice%' AND StartName NOT LIKE '%localsystem%'")
If (Err.Number = 0 and not colServiceList.count = 0) Then
	Err.Clear
	WScript.Echo "Name: " , strComputer , " " , colServiceList.count
	For Each objService in colServiceList
		WScript.Echo vbTab & objService.DisplayName & " " & objService.StartName & " " & objService.StartMode
	Next
	WScript.Echo vbLf
Else
	DisplayErrorInfo strComputer
End If
	

Sub DisplayErrorInfo(strCompName)

	'WScript.Echo "Error:      : " & Err
	'WScript.Echo "Error (hex) : &H" & Hex(Err)
	'WScript.Echo "Source      : " & Err.Source
	'WScript.Echo strCompName & " : " & Err.Description
	Err.Clear

End Sub