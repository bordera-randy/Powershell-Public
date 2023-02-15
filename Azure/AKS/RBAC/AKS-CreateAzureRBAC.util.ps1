
# To connect to Cluster 
$clusterRG       = 'VALUEHERE'
$clustername     = 'VALUEHERE'
$sub             = 'VALUEHERE'

az account set --subscription $sub
az aks get-credentials --resource-group $clusterRG --name $clustername


kubectl apply -f .\yaml\readpermissions.yaml 
kubectl apply -f .\yaml\aksreadaccess.yaml  


Add-AzureADGroupMember  `
    -ObjectId 'VALUEHERE' `
    -RefObjectId 'VALUEHERE'



