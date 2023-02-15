import-module ActiveDirectory 
 
#Set the domain to search at the Server parameter. Run powershell as a user with privilieges in that domain to pass different credentials to the command. 
#Searchbase is the OU you want to search. By default the command will also search all subOU's. To change this behaviour, change the searchscope parameter. Possible values: Base, onelevel, subtree 
#Ignore the filter and properties parameters 
 
$ADUserParams=@{ 
'Server' = 'bosa-dc03.bofsa.local' 
'Searchbase' = 'OU=Forum,OU=Users,OU=BOSA,DC=BOFSA,DC=LOCAL' 
'Searchscope'= 'Subtree' 
'Filter' = '*' 
'Properties' = '*' 
} 
 
#This is where to change if different properties are required. 
 
$SelectParams=@{ 
'Property' = 'SAMAccountname', 'CN', 'title', 'EmailAddress'
} 
 
get-aduser @ADUserParams | select-object @SelectParams  
