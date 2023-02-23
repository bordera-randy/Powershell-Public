<########################################################################################################################################################
    Name: MarkasRead-TeamsChat.ps1
    Author: Randy Bordeaux 
    Date Created: 2/23/2023
    Date Modified:
    
    Description: 
        Mark all messages as read in Microsoft Teams.
        This script uses the built-in function ‘MgMarkChatReadForUser’ to iterate over the chats and get them marked as read.
        Note : Please make sure you sign-in as the same user whose UPN you have provided as the parameter for the script.
        
        Read-TeamsChatMessage -UserUPN "john.smith@contoso.com" 

    Requirements: 
        Please install the Microsoft Graph PowerShell module before running this script.
                Install-Module Microsoft.Graph -Scope AllUsers
########################################################################################################################################################>

function Read-TeamschatMessage
{  
     param (  
           $UserUPN
           )  
    process
    {
        Import-Module Microsoft.Graph.Teams  
        Connect-MgGraph -Scopes "Chat.ReadWrite" ,"User.Read"

        #To Get Tenant Id
        $Tenant= Get-MgOrganization 
        $TenantId= $Tenant.Id
        $Chats =Get-MgUserChat -UserId $UserUPN -ExpandProperty "members" 
        $User = $Chats[0].Members | Where-Object {$_.AdditionalProperties.email -eq $UserUPN} | select AdditionalProperties
        $UserId = $User.AdditionalProperties.userId
        foreach($chat in $Chats)
        {
            $params = @{

                User = @{
                    Id = $UserId
                    tenantId = $TenantId
                }
            }
            Invoke-MgMarkChatReadForUser -ChatId  $chat.Id -BodyParameter $params 
         }
         Disconnect-MgGraph
    }
}
Read-TeamsChatMessage -UserUPN "user@domain.com"