' ===============================================================================================================
' Get All Group-Membership of a User
' This Script will list All Groups, Including Nested Groups, Where a specified User-Account is a Member
' ===============================================================================================================

Option Explicit

Dim ObjUser, ObjRootDSE, ObjConn, ObjRS
Dim GroupCollection, ObjGroup
Dim StrUserName, StrDomName, StrSQL

WScript.Echo vbNullString
' --- Force The User To Pass a User-Name (User's Login ID, i.e SAM Account Name)
If WScript.Arguments.Count <> 1 Then
	WScript.Echo "Error: NO USER-NAME ENTERED"
	WScript.Echo "Usage:  ScriptName <Group-Name>"
	WScript.Echo "Example: " & Trim(WScript.ScriptName) & " " & "BobS"
	WScript.Quit
End If

Set ObjRootDSE = GetObject("LDAP://RootDSE")
StrDomName = Trim(ObjRootDSE.Get("DefaultNamingContext"))
Set ObjRootDSE = Nothing

' -- Capture the UserID Entered
StrUserName = Trim(WScript.Arguments(0))
StrSQL = "Select ADsPath From 'LDAP://" & StrDomName & "' Where ObjectCategory = 'User' AND SAMAccountName = '" & StrUserName & "'"

Set ObjConn = CreateObject("ADODB.Connection")
ObjConn.Provider = "ADsDSOObject":	ObjConn.Open "Active Directory Provider"
Set ObjRS = CreateObject("ADODB.Recordset")
ObjRS.Open StrSQL, ObjConn
If Not ObjRS.EOF Then
	ObjRS.MoveLast:	ObjRS.MoveFirst
	WScript.Echo "Getting All Group-Membership of User: " & StrUserName & ". Please wait ..."
	WScript.Echo vbNullString
	Set ObjUser = GetObject (Trim(ObjRS.Fields("ADsPath").Value))
	Set GroupCollection = ObjUser.Groups
	WScript.Echo "User " & StrUserName & " is a Member of all the following Groups:"
	For Each ObjGroup In GroupCollection
		WScript.Echo "  >> " & Trim(ObjGroup.CN)
		' -- Now List all Nested Groups of which the User is a Member
		CheckForNestedGroup ObjGroup
	Next
	Set ObjGroup = Nothing:	Set GroupCollection = Nothing:	Set ObjUser = Nothing
	WScript.Echo vbNullString
Else
	WScript.Echo "User: " & StrUserName & " does not exist in Active Directory"
End If
ObjRS.Close:	Set ObjRS = Nothing
ObjConn.Close:	Set ObjConn = Nothing

Private Sub CheckForNestedGroup(ObjThisGroupNestingCheck)
	On Error Resume Next
	Dim AllMembersCollection, StrMember, StrADsPath, ObjThisIsNestedGroup
	AllMembersCollection = ObjThisGroupNestingCheck.GetEx("MemberOf")
    For Each StrMember in AllMembersCollection
        StrADsPath = "LDAP://" & StrMember
        Set ObjThisIsNestedGroup = GetObject(StrADsPath)
        WScript.Echo "  >> " & Trim(ObjThisIsNestedGroup.CN) & " ---- This is a Nested Group"
        CheckForNestedGroup(ObjThisIsNestedGroup)
    Next
	Set ObjThisIsNestedGroup = Nothing:	Set StrMember = Nothing:	Set AllMembersCollection = Nothing
End Sub