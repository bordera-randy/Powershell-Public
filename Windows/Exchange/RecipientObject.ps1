<#
.SYNOPSIS
    RecipientObject.ps1
.DESCRIPTION
    .<Text>
.PARAMETER Recipient
 	
	By default this script will make a similar name search on $Recipient. 
	For exact name search prepend $Recipient with "^"
	To skip a search type "^"
	
	Searched fields: 
	
	- Name 
	- DisplayName
	- Alias
	- DistinguishedName
	- SamAccountName
	- Guid (works only as exact name search ) 
      
   
.PARAMETER Silent
    If selected makes the script to not output anything
	
	
.EXAMPLE
    C:\PS> 
    <Description of example>
.NOTES
    Author: Filip Neshev; filipne@yahoo.com
    Date:01/2016       
#>



param(
    		[parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Search string ")]
			$Recipient,
			[parameter(Position=1,Mandatory=$false,ValueFromPipeline=$false,HelpMessage="Silent ")]
			[switch]$Silent, 
			[parameter(Position=2,Mandatory=$false,ValueFromPipeline=$false,HelpMessage="Recipient Type Details ")]
			[ValidateSet("DynamicDistributionGroup", "EquipmentMailbox","LinkedMailbox","MailContact", "MailNonUniversalGroup","MailUniversalDistributionGroup" , "MailUniversalSecurityGroup", "MailUser" , "PublicFolder" , "RoomList" , "RoomMailbox" , "SharedMailbox"  , "UserMailbox", "RemoteSharedMailbox", "RemoteUserMailbox" ) ] 
			[string]$RecipientTypeDetails,
			[parameter(Position=3,Mandatory=$false,ValueFromPipeline=$false,HelpMessage="Exact Name search ")]
			[switch]$ExactEmailSearch
	)
	
	

	
begin 
{
	
	
	function Display ($RecipientObjects) 
	{
				if( $($RecipientObjects.Length) -gt 1 )
				{		
				
					$Continue = $false
					
					if( $($RecipientObjects.Length) -gt 20 )
					{
							Write-Host ""
							Write-Host "	" -NoNewline
							Write-Host "  WARNING :	 [ $($RecipientObjects.Length) ]  results found ! Continue ?"  -ForegroundColor	Red	-BackgroundColor	yellow
							Write-Host ""
					
					$Continue = Read-Host "Enter to display all , Type anything to skip  "
					
					}
					
					if (!$Continue )
					{
						Write-Host ""
						Write-Host " [ $($RecipientObjects.Length) ] results found 	" -ForegroundColor Cyan	-BackgroundColor	Blue
						Write-Host ""
						Write-Host ($RecipientObjects | select Guid, RecipientTypeDetails, Name, @{Label="Hidden?"; Expression= { $_.HiddenFromAddressListsEnabled } } , PrimarySmtpAddress,   EmailAddresses | sort RecipientTypeDetails, Name | ft -AutoSize -Wrap  | Out-String) -foregroundcolor Cyan
						Write-Host ""
					
					}
					
				}
				else
				{
					Write-Host ""
					Write-Host ($RecipientObjects | select Guid, RecipientTypeDetails, Name, @{Label="Hidden?"; Expression= { $_.HiddenFromAddressListsEnabled } } ,PrimarySmtpAddress,  EmailAddresses | sort RecipientTypeDetails, Name | ft -AutoSize -Wrap | Out-String).Trim() -foregroundcolor Cyan
					Write-Host ""
					
				}


	} # function Display ($RecipientObjects)
	
	
	
	$RecipientTypeDetailsParameter = $RecipientTypeDetails
	
	if(!$Silent)
	{
	
		Write-Host "RecipientObject.ps1	Created by Filip Neshev, January 2016	filipne@yahoo.com" -ForegroundColor Cyan  -backgroundcolor  DarkGray	
		
	}
	
	Write-Host "" 

} # begin 


process
{
		
	$Recipient = $Recipient.Replace("," , " ")
	
	$dashCount = ($Recipient.ToCharArray()  | Where-Object {$_ -eq "-" } | Measure-Object).Count
	
	$RecipientObject =$null


	while( $RecipientObject.Length -ne 1 )
	{
		$RecipientObject = @()
			
		if ( $Recipient -eq "*" )
		{ 
			
			if ( $RecipientTypeDetails -and  $RecipientTypeDetailsParameter)
			{
				Write-Host ""
				Write-Host "`$RecipientObject  = @(Get-Recipient -ResultSize	unlimited  -RecipientTypeDetails $RecipientTypeDetails -DomainController $DC)" -ForegroundColor Yellow
				Write-Host ""
				
				$RecipientObject  = @(Get-Recipient -ResultSize	unlimited  -RecipientTypeDetails $RecipientTypeDetails )
				
				if (!$Silent )
				{
					
					Display $RecipientObject
			
				}
				
								
				return  $RecipientObject  
			}
			
		
		}
		
		
		while ( $Recipient.Length -lt 3  )
		{ 
			
			if ( $Recipient -ne "^" )
			{
				$Recipient = read-host -prompt "Enter  Recipient Name of at least (3) chars or CTRL+C to exit "
			}
			elseif ( $Recipient -eq "^")
			{ 
	
				Write-Host ""
				Write-Host "	" -NoNewline
				Write-Host "  ATTENTION :  Recipient skipped !" -ForegroundColor  Blue	-BackgroundColor	Yellow
				
				
				
				return  $RecipientObject  
		
			}
			
		} #while ( $Recipient.Length -lt 3  )
	

	
			$dashCount = ($Recipient.ToCharArray()  | Where-Object {$_ -eq "-" } | Measure-Object).Count
			
			if( $dashCount -eq 4 )
			{	
				# guid provided as Recipient. Forcing exact name search
				$Recipient = "^" + $Recipient 
			}	

			
			$ExactNameSearchOptionRecipient = $Recipient.IndexOf( '^' )
			

			if ( !$ExactNameSearchOptionRecipient )
			{ $Recipient = $Recipient.Replace("^", "") }
			
			if($Recipient) 	{ 	$Recipient = $Recipient.Trim() 	}
			
			
			if($Recipient.Contains("@") ) 
			{
				# Email address search 
			
				Write-Host ""
				Write-Host "Email address search...." -Foregroundcolor Cyan -BackgroundColor BLUE
				Write-Host ""
				
				if ( !$ExactNameSearchOptionRecipient -or $ExactEmailSearch)
				{
					#Exact email search 
					$sb = [scriptblock]::create("EmailAddresses -eq `"$Recipient`"")
				
				}
				else
				{
					#Similar email search
					$sb = [scriptblock]::create("EmailAddresses -like `"*$Recipient*`"")
				
				}
			}
			else
			{
				# NOT email search
	
				if( $ExactNameSearchOptionRecipient )
				{
					# Similar name search requested
					
					if(!$Silent)
					{
						Write-Host ""
						Write-Host "Similar name search...." -Foregroundcolor Cyan -BackgroundColor BLUE
						Write-Host ""
					}
					
					$Recipient = "*$Recipient*"
	
			
			$SBString = @"
 Name -like `"$Recipient`"
-or DisplayName -like `"$Recipient`"
-or Alias -like `"$Recipient`" 
-or DistinguishedName -like `"$Recipient`"
-or SamAccountName -like `"$Recipient`" 
"@
		
				}
				elseif ( $dashCount -eq 4 )
				{	# Guid Search 
					
						$SBString = @"
Guid -eq `"$Recipient`"
"@
		
				}
				else
				{
					#	Exact name search 
						
					if(!$Silent)
					{
						Write-Host ""
						Write-Host "Exact name search...." -Foregroundcolor Cyan -BackgroundColor BLUE
						Write-Host ""
					}
			
						$SBString = @"
Name -eq `"$Recipient`"
-or DisplayName -eq `"$Recipient`"
-or Alias -eq `"$Recipient`" 
-or DistinguishedName -eq `"$Recipient`" 
-or SamAccountName -eq `"$Recipient`"
"@
				}
				
					
			$sb = [scriptblock]::create($SBString) 
			
		
			}## NOT email search
		

		$Recipient =""
		

		
		if ($RecipientTypeDetails -and $RecipientTypeDetailsParameter )
		{ 	
			
			$RecipientObject = @(Get-Recipient -Filter $sb  -RecipientTypeDetails $RecipientTypeDetails  ) 
			
			if(!$Silent) { 	Write-Host "`$RecipientObject = @( Get-Recipient -Filter $sb  -RecipientTypeDetails $RecipientTypeDetails -DomainController $DC  )" -ForegroundColor Yellow }
			
			
		
		}
		else
		{   
			
			$RecipientObject = @(Get-Recipient -Filter $sb  )  
			
			if(!$Silent) { 	Write-Host "`$RecipientObject = @( Get-Recipient -Filter{ $sb } -DomainController $DC  )" -ForegroundColor Yellow }
		}
			

		
		if(!$Silent )
		{
				
		Display $RecipientObject
		
				
		}




	
} # while( $RecipientObject.Length -ne 1 )
						
			$RecipientTypeDetails = $RecipientObject[0].RecipientTypeDetails
			$guid = $RecipientObject[0].Guid

	
			
			if($RecipientTypeDetails -eq "UserMailbox" -or  $RecipientTypeDetails -eq  "SharedMailbox" -or  $RecipientTypeDetails -eq "LinkedMailbox" -or  $RecipientTypeDetails -eq "RoomMailbox")
			{
 
			}
			elseif ($RecipientTypeDetails -eq "MailUniversalDistributionGroup")
			{

			}
			
			elseif ( $RecipientTypeDetails -eq "PublicFolder" )
			{
					
					$mailPublicFolder = Get-mailPublicFolder $RecipientObject.guid.tostring()
					
					$PublicFolder = Get-PublicFolder $mailPublicFolder.EntryId
					
			
					Write-Host ""
				 					
									
				
					
					$PublicFolder = Get-PublicFolder $mailPublicFolder.EntryId 
					
					
					Write-Host "Get-PublicFolder $($mailPublicFolder.EntryId)" -ForegroundColor Yellow
					
					Write-Host ""
					
					Write-Host (  $PublicFolder | fl | Out-String  ).Trim()	-foregroundcolor Cyan
					
					Write-Host ""
					Write-Host "Get-PublicFolderstatistics $($mailPublicFolder.EntryId)" -ForegroundColor Yellow
					Write-Host ""
					
					Write-Host (  Get-PublicFolderstatistics $PublicFolder.EntryId | fl | Out-String ).Trim()	-foregroundcolor Cyan	
					
					Write-Host ""	
					Write-Host ""	
					Write-Host ""						
					Write-Host "`$ClientPermission = Get-PublicFolderClientPermission ' $($PublicFolder.Identity ) ' " -ForegroundColor Yellow
					Write-Host ""
									
								
					$ClientPermission = Get-PublicFolderClientPermission $($PublicFolder.Identity).tostring()
					
					$ClientPermission = $ClientPermission | sort AccessRights
									
					Write-Host ($ClientPermission | ft AccessRights, User  -AutoSize | Out-String) -foregroundcolor Cyan
					
									
			}
	
	
	return $RecipientObject
	
	
	} #process
	
	
	end 
	{
		#Write-Host ""
		Write-Host "  End of Script  RecipientObject.ps1 " -ForegroundColor DarkBlue	-BackgroundColor Gray
		Write-Host ""
	}
	