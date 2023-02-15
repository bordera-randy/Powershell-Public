'Sub lstUserGUID(sAPP, iVersion)
	'On Error Resume Next
	iFound = 0 'place holder if not found
	Const HKU = &H80000003
	Set WshShell = WScript.CreateObject("WScript.Shell")
	Set WshNetwork = WScript.CreateObject("Wscript.Network")
	Set oReg = GetObject("winmgmts:\\" & WshNetwork.ComputerName & "\root\default:StdRegProv")
	strKeyPath = ""
	oReg.EnumKey HKU, strKeyPath, arrSubKeys
	For Each subkey In arrSubKeys
		If InStr(1,subkey,"S-1-5-21") Then
			WScript.Echo subkey
		End If
'			 disHolder = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" _
'			 & subkey & "\DisplayName")
'			 disVer =  WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" _
'			 & subkey & "\DisplayVersion")
'		If instr(1, disHolder, sAPP, 1) = 1 Then
'				iFound = 1
'				uninst =  WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" _
'				& subkey & "\UninstallString")
'				myArray = split(disVer, ".")
'				t = ""
'			For Each x In myArray
'				t = t & x
'			Next
'			If CLng(t) >= CLng(iVersion) Then
'				Wscript.echo disHolder & " " & disVer & " : " & uninst
'				logfile(disHolder + " :  " + disVer + " : ")
'			ElseIf CLng(t) < CLng(iVersion) Then
'				Wscript.echo disHolder & " " & disVer & " Version Deficiency " & uninst
'				miMsg = disHolder & " Version Deficiency " & disVer & " : "
'				logfile(miMsg)
'			End If
'		End If
	Next
	'If iFound = 0 Then logfile(sAPP + " not found")
'End Sub