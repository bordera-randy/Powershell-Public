http://www.flobee.net/automatically-disable-activesync-for-new-mailboxes-in-exchange-2010/

Automatically disable ActiveSync for new mailboxes in Exchange 2010
Posted on June 30, 2010 by Scott — 9 Comments ↓
One of the new features in Exchange 2010 is the use of cmdlet extension agents, as described in this post. Using the Scripting Agent you can have Exchange ActiveSync disabled whenever a mailbox is created for a new or existing user. This removes the need to do it directly against Active Directory through some workflow mechanism or scheduling a task to run that does it with the Set-CASMailbox cmdlet.

There is almost no documentation on the use of the provisioning handler for Exchange 2010, leaving me to do a lot of trial and error to get it working for new mailboxes for both new and existing users. It doesn’t look like the provisioning handler has access to any of the information returned by the success of the New-Mailbox and Enable-Mailbox cmdlets. This means it only has access to the information submitted by the user in a cmdlet. Because you supply different information when creating a mailbox for a new user compared to an existing one, the code has to be different for each.

Copy the code below into the ScriptingAgentConfig.xml file and, as Pat Richard’s post details, put it in the CmdletExtensionAgents directory and enable the Scripting Agent.

<?xml version="1.0" encoding="utf-8" ?>
<Configuration version="1.0">
    <Feature Name="MailboxProvisioning" Cmdlets="enable-mailbox">
        <ApiCall Name="OnComplete">
            if($succeeded)
                {
                $user = (Get-User $provisioningHandler.UserSpecifiedParameters["Identity"]).distinguishedName
                Set-CASMailbox $user -ActiveSyncEnabled $false
                }
        </ApiCall>
    </Feature>
    <Feature Name="MailboxProvisioning" Cmdlets="new-mailbox">
        <ApiCall Name="OnComplete">
            if($succeeded)
                {
                $user = (Get-User $provisioningHandler.UserSpecifiedParameters["Name"]).distinguishedName
                Set-CASMailbox $user -ActiveSyncEnabled $false
                }
        </ApiCall>
    </Feature>
</Configuration>