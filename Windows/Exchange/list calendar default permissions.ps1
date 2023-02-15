# Get the mailboxes 
###########CHANGE FILTER HERE TO LIMIT RESULTS####################
$Mailboxes = Get-Mailbox -Filter {RecipientTypeDetails -eq "UserMailbox"} -ResultSize unlimited
###############END CHANGES########################################
# An array for the output 
$Output = @()   
# Loop through the mailboxes 
ForEach ($Mailbox in $Mailboxes) {
  # Get the name of the calendar folder  
  $Calendar = (($Mailbox.PrimarySmtpAddress.ToString())+ ":\Calendar")

  # Get the permissions on the folder  
  $Permissions = Get-MailboxFolderPermission -Identity $Calendar -user "Default"
  
  # Loop through the permissions, populating the output array.  This pulls the primary information  
  ForEach ($Permission in $Permissions) {
    $Members = @()
	#Use -Debug to get the results displayed   
    Write-Debug $Permission.user.ToString()
    
    #Filter list of known groups you do not want to recurse (ie. Default, Anonymous, any group containing all)
    ###########CHANGE FILTER HERE TO LIMIT GROUPS YOU DO NOT WANT TO RECURSE####################
    If ($Permission.user.ToString() -eq 'Default' -or $Permission.user.ToString() -eq 'Anonymous'  -or $Permission.user.ToString() -like '*all*') {
    ###############END CHANGES########################################
    #add filtered groups as single members, rather than recurse the group members    
        $Permission | Add-Member -MemberType NoteProperty -Name "Mailbox" -value $Mailbox.DisplayName   
        $Output = $Output + $Permission 
    } Else {
    #Check for AD information
        $User = Get-User $Permission.user.ToString() -ErrorAction SilentlyContinue
	if (!$User)
	{
	#Assume it is a group, recurse through members
	$Members += Get-GroupMembersRecursive $Permission.user.ToString();
	} else {
	#Assume it is a single user add one member to the list
	$Members += $User.UserPrincipalName
	}
	#Go through list of users and populate a row for each member that has this set of permissions
	ForEach ($Member in $Members) {
		#Clone the object rather than point the reference, otherwise you get an infinate loop
        $ThisPermission = $Permission.clone()
        $ThisPermission | Add-Member -MemberType NoteProperty -Name "Mailbox" -value $Mailbox.DisplayName   
        $ThisPermission | Add-Member -MemberType NoteProperty -Name "EndUser" -value $Member  
        #Add object to output array list 
        $Output = $Output + $ThisPermission 
        }
    } 
    }
  }  
  
  # Write the output to a CSV file 
  $Output | Select-Object Mailbox, User, EndUser, {$_.AccessRights}, IsValid | Export-Csv -Path c:\temp\test.csv -NoTypeInformation