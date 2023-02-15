
search-mailbox -identity "ksmith" -searchquery 'to:"thesmiths125@yahoo.com"' -targetmailbox "sa.managediron" -targetfolder "ksmith" -logonly -loglevel full

get-messagetrackinglog -sender "kacy.smith@thebankofsa.com" -start "11/01/2016 00:01:01" -end "05/17/2018 12:01:01" -recipients "thesmiths125@yahoo.com" -resultsize unlimited -eventid submit | ft -wrap -autosize | export-csv c:\support\ksmith_tracking_log.csv
search-mailbox -identity "sbrinson" -searchquery 'subject:"RDC" AND to:"wilsonsr86@gmail.com"' -targetmailbox "sa.managediron" -targetfolder "sbrinson" -logonly -loglevel full
Get-Mailbox nguenther | Search-Mailbox -SearchQuery {Received:"09/16/2017 00:01..10/16/2017 23:59"} -targetmailbox "sa.managediron" -targetfolder "nguenthersearch" -logonly -loglevel full


Search-Mailbox -identity ksmith -EstimateResultOnly -IncludeUnsearchableItems -SearchQuery "to:thesmiths125@yahoo.com" | Add-Member -MemberType ScriptProperty -Name testsize -Value {$this.ResultItemsSize.replace â€œ(.*\()|,| [a-z]*\)â€, â€œâ€} | select-object displayname, resultitemscount, testsize | export-csv -path "c:\users\sa.managediron\desktop\output.csv"  

 Search-Mailbox -identity sa.managediron -EstimateResultOnly -IncludeUnsearchableItems -SearchQuery "from:synserv" | Add-Member -MemberType ScriptProperty -Name testsize -Value {$this.ResultItemsSize.replace â€œ(.*\()|,| [a-z]*\)â€, â€œâ€} | select-object displayname, resultitemscount, testsize | export-csv -path "c:\users\sa.managediron\desktop\output.csv" 

Get-Mailbox nguenther | Search-Mailbox -SearchQuery {Received:"09/16/2017 00:01..10/16/2017 23:59"} -targetmailbox "sa.managediron" -targetfolder "nguenthersearch" -logonly -loglevel full


Get-Mailbox | Search-Mailbox -SearchQuery 'leslie robinson'  -loglevel full 

-TargetMailbox "Discovery Search Mailbox" -TargetFolder "AllMailboxes-Election" -LogLevel Full
get-messagetrackinglog 

Search-Mailbox -Identity "April Stewart" -SearchQuery 'Subject:"Your bank statement"' -TargetMailbox "administrator" -TargetFolder "SearchAndDeleteLog" -LogOnly -LogLevel Full

Search-Mailbox -Identity "Joe Healy" -SearchQuery "Subject:Project Hamilton" -TargetMailbox "DiscoveryMailbox" -TargetFolder "JoeHealy-ProjectHamilton" -LogLevel Full

Search-Mailbox -Identity "April Stewart" -SearchQuery 'Subject:"Your bank statement"' -DeleteContent


Get-Mailbox | Search-Mailbox -SearchQuery 'election OR candidate OR vote' -TargetMailbox "Discovery Search Mailbox" -TargetFolder "AllMailboxes-Election" -LogLevel Full

