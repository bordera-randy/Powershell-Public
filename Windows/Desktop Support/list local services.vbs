Option Explicit
Dim strComputer,strExclude,strSearchFor,strState,wshNetwork,fso,resFile,arrExclude,arrSearchFor,x,bFound,objWMIService,objService
Dim colListOfServices

strSearchFor = ".,\,/,@"
'strExclude = "localsystem,localservice,networkservice"
strExclude = "service,local"

Set wshNetwork = CreateObject( "WScript.Network" )
strComputer = wshNetwork.ComputerName

Set fso = CreateObject ("Scripting.FileSystemObject")
Set resFile = fso.CreateTextFile (".\Results.csv")

resFile.WriteLine "Computer,Service Type,Name,State,Run As"

arrSearchFor = Split(strSearchFor, ",")
arrExclude = Split(strExclude, ",")
for x = 0 to ubound(arrExclude)
	wscript.echo Trim(Ucase(arrExclude(x))) & " " & x
Next 

scanServices(strComputer)

Sub scanServices(strComputer)
	'progressText strComputer,"Scanning Services for"
	bFound = False
	On Error Resume Next
	Err.Clear
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	If Err.Number <> 0 Then
		wscript.echo "Error in the getobject " & Err.Number
		Exit Sub
	End If
	Set colListOfServices = objWMIService.ExecQuery("Select * from Win32_Service")
	If Err.Number <> 0 Then
		wscript.echo "Error in the ExecQuery " & Err.Number
		Exit Sub
	End If

	For Each objService in colListOfServices
		bFound = False
		For x = 0 to UBound(arrExclude)
			'If InStr(UCase(objService.StartName), Trim(Ucase(arrSearchFor(x)))) > 0 Then
			wscript.echo objService.DisplayName & " Instr is " & InStr(UCase(objService.StartName), Trim(Ucase(arrExclude(x)))) & " arrExclude is " & UCase(arrExclude(x)) & " x is " & x
			'wscript.echo objService.DisplayName & " is runnning as " & UCase(objService.StartName) & " x is " & x
			If InStr(UCase(objService.StartName), Trim(Ucase(arrExclude(x)))) = 0 Then
				bFound = True
				'wscript.echo InStr(UCase(objService.StartName), Trim(Ucase(arrExclude(x)))) & " " & x
			End If
		Next
		
		If bFound = True Then

			'wscript.echo objService.DisplayName & " is runnning as " & UCase(objService.StartName)
			
			If objService.Started = True Then
				strState = "Started"
			Else
				strState = "Not Running"
			End If
			
			strState = objService.StartMode & "/" & strState
			resFile.WriteLine strComputer & ",Service," & objService.DisplayName & "," & strState & "," & objService.StartName
		End If
   Next

   Set objWMIService = Nothing
End Sub