strSearchFor = "sa.backup,sa.managediron"
strExclude = "Local System,Local Service,Network Service"


Set fso = CreateObject ("Scripting.FileSystemObject")
Set resFile = fso.CreateTextFile (".\Results.csv")

resFile.WriteLine "Computer,Service Type,Name,State,Run As"

arrSearchFor = Split(strSearchFor, ",")
arrExclude = Split(strExclude, ",")

Dim arrTextLine(9)
const crlf="<BR>"
Set objExplorer = WScript.CreateObject("InternetExplorer.Application")
objExplorer.Navigate "about:blank"   
objExplorer.ToolBar = 0
objExplorer.StatusBar = 0
objExplorer.Width = 400
objExplorer.Height = 300 
objExplorer.Left = 100
objExplorer.Top = 100

Do While (objExplorer.Busy)
	Wscript.Sleep 200
Loop

objExplorer.Visible = 1    

Sub scanServices(strComputer)
	progressText strComputer,"Scanning Services for"
	On Error Resume Next
	Err.Clear
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	If Err.Number <> 0 Then
		'wscript.echo Err.Number
		Exit Sub
	End If
	Set colListOfServices = objWMIService.ExecQuery("Select * from Win32_Service")
	If Err.Number <> 0 Then
		'wscript.echo Err.Number
		Exit Sub
	End If

	For Each objService in colListOfServices
		bFound = False
		For x = 0 to UBound(arrSearchFor)
			If NOT InStr(UCase(objService.StartName), Trim(Ucase(arrExclude(x)))) > 0 Then
				bFound = True
			End If
		Next
		
		If bFound = True Then
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