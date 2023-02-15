Option Explicit

Dim objFSO, strTextFile, arrLines(), fsoFile, count
CONST ForReading = 1
CONST TristateTrue = -1

strTextFile = "C:\Scripts\Logs\current-ScriptLog.txt"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set fsoFile = objFSO.OpenTextFile(strTextFile,ForReading,False,TristateTrue)

count = 0
Do Until fsoFile.AtEndOfStream
	Redim Preserve arrLines(count)
	arrLines(count) = fsoFile.ReadLine
	count = count + 1a
Loop

WScript.echo arrLines(7)