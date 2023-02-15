Option Explicit

Dim wshNetwork, strComputer, strCompName, objComputer, colServiceList, objService, fso, outFile, strState

On Error Resume Next

Set fso = CreateObject ("Scripting.FileSystemObject")
Set outFile = fso.CreateTextFile (".\Results.csv")

outFile.WriteLine "Computer,Service Type,Name,State,Run As"

Set wshNetwork = CreateObject( "WScript.Network" )
strComputer = wshNetwork.ComputerName	

Set objComputer = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
If Err.Number = 0 Then
	Err.Clear
	Set colServiceList = objComputer.ExecQuery ("Select * from Win32_Service Where (NOT StartName LIKE '%localservice%') AND (NOT StartName LIKE '%networkservice%') AND (NOT StartName LIKE '%localsystem%')")
	wscript.echo "colservicelist count is " & colServiceList.count
	wscript.echo "error number is " & err.number
	If Err.Number = 0 AND colServiceList.count <> 0 Then
		Err.Clear
		'WScript.Echo "Name: " , strComputer , " " , colServiceList.count
		wscript.echo "You have entered the Twilight Zone"
		
		For Each objService in colServiceList
			'WScript.Echo vbTab & objService.DisplayName & " " & objService.StartName & " " & objService.StartMode
			If objService.Started = True Then
				strState = "Started"
			Else
				strState = "Not Running"
			End If
			strState = objService.StartMode & "/" & strState
			outFile.WriteLine strComputer & ",Service," & objService.DisplayName & "," & strState & "," & objService.StartName
		Next
	ElseIf colServiceList.count = 0 Then
		wscript.echo "This computer has no non-system services"
		wscript.quit
	Else
		wscript.echo "In the colServiceList"
		DisplayErrorInfo strComputer
	End If
Else
	wscript.echo "could not make wmi to localhost"
	DisplayErrorInfo strComputer
End If

wscript.echo "you are ending at the end of the script"
Sub DisplayErrorInfo(strCompName)

	WScript.Echo "Error:      : " & Err
	'WScript.Echo "Error (hex) : &H" & Hex(Err)
	'WScript.Echo "Source      : " & Err.Source
	'WScript.Echo strCompName & " : " & Err.Description
	Err.Clear

End Sub