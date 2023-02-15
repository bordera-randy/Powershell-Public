



$path = 'VALUEHERE'
mkdir $path

k get rolebindings,clusterrolebindings --all-namespaces -o custom-columns='NAME:metadata.name,NAMESPACE:metadata.namespace,KIND:kind' >> $($path + "rolebindings.txt")
k get roles --all-namespaces >> $($path + "roles.txt")



