Option Explicit

Dim objFSO, strTextFile, strData, strLine, arrLines, aniTextFile, aniData, aniLines, meLine, objTextFile, fso, inputFileList, sFolderName, fname
Dim iim1, iret, iret2, iret3, i, wshShell
CONST ForReading = 1

Set wshShell = CreateObject( "WScript.Shell" )


'strTextFile = "C:\Scripts\Logs\currentscriptlog.txt"
strTextFile =  wshShell.ExpandEnvironmentStrings("%USERPROFILE%") + "Desktop\currentscriptlog.txt"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set fsoFile = objFSO.OpenTextFile(strTextFile,1)

Do Until fsoFile.AtEndOfStream
	arrLines = fsoFile.ReadLine
Loop
	

For Each strLine in arrLines
	WScript.Echo strLine
Next