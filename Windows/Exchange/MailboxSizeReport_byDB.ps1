get-MailboxStatistics -database mdb06 | where {$_.ObjectClass –eq “Mailbox”} | Sort-Object TotalItemSize –Descending `
    | ft @{label=”User”;expression={$_.DisplayName}},@{label=@{label=”Total Size (MB)”;expression={$_.TotalItemSize.Value.ToMB()}},@{label=”Items”; `
        expression={$_.ItemCount}},@{label=”Storage Limit”;expression={$_.StorageLimitStatus}}} -AutoSize