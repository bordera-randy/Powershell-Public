import-module activedirectory
get-aduser -identity ACCOUNTNAMEHERE -properties passwordlastset | ft name, passwordlastset, passwordneverexpires