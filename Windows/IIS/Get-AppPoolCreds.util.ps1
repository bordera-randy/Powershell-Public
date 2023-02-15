Import-Module WebAdministration

$app = get-childItem -Path IIS:\AppPools\ | Where-Object { $_.processModel.identityType -eq "SpecificUser" } | select-object -first 1

$identity = $app.processModel

$ServiceUsername = $identity.userName

$Servicepassword = $identity.password