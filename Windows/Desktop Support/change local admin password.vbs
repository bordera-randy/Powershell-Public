
Set WshNetwork = WScript.CreateObject("WScript.Network")
strComputer = "."
Set objUser = GetObject("WinNT://" & strComputer & "/Administrator,user")
objUser.SetPassword "NEW.PASSWORD" ' Enter new password between brackets
objUser.SetInfo