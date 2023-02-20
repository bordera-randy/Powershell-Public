
0. Impersonate a user and group
     kubectl get pods --as-group="somecompany:somecompany-teamname" --as="test"

1. Explain a resource
     ❯ kubectl explain hpa
     KIND:     HorizontalPodAutoscaler
     VERSION:  autoscaling/v1
     DESCRIPTION:
          configuration of a horizontal pod autoscaler.
     FIELDS:
     apiVersion   <string>
          APIVersion defines the versioned schema of this representation of an
          object. Servers should convert recognized schemas to the latest internal
          value, and may reject unrecognized values. More info:
          https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
     kind <string>
          Kind is a string value representing the REST resource this object
          represents. Servers may infer this from the endpoint the client submits
          requests to. Cannot be updated. In CamelCase. More info:
          https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
     metadata     <Object>
          Standard object metadata. More info:
          https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
     spec <Object>
          behaviour of autoscaler. More info:
          https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status.
     status       <Object>
          current information about the autoscaler.
     kubectl explain svc
2. Get nodes region and zone
     ❯ kubectl get nodes --label-columns failure-domain.beta.kubernetes.io/region,failure-domain.beta.kubernetes.io/zone
     NAME                                        STATUS   ROLES    AGE     VERSION               REGION      ZONE
     ip-11-0-109-70.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   eu-west-1   eu-west-1b
     ip-11-0-148-55.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   eu-west-1   eu-west-1a
     ip-11-0-186-88.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   eu-west-1   eu-west-1c
3. Get All Labels
     ❯ kubectl get nodes --show-labels
     NAME                                        STATUS   ROLES    AGE     VERSION               LABELS
     ip-11-0-109-70.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   alpha.eksctl.io/cluster-name=dev-cluster-1,alpha.eksctl.io/instance-id=i-04c61a8ef573ef91b,alpha.eksctl.io/nodegroup-name=dev-cluster-1001-stateless,beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m5.large,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eu-west-1,failure-domain.beta.kubernetes.io/zone=eu-west-1b,kubernetes.io/arch=amd64,kubernetes.io/hostname=ip-11-0-109-70.eu-west-1.compute.internal,kubernetes.io/os=linux,node-lifecycle=on-demand
4. Get all nodes labelled Node-Class (and label it)
     ❯ kubectl get nodes
     NAME                                        STATUS   ROLES    AGE     VERSION
     ip-11-0-109-70.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801
     ip-11-0-148-55.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801
     ip-11-0-186-88.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801
     ❯ kubectl label node ip-11-0-148-55.eu-west-1.compute.internal node-class=test
     node/ip-11-0-148-55.eu-west-1.compute.internal labeled
     ❯ kubectl get nodes --label-columns node-class
     NAME                                        STATUS   ROLES    AGE     VERSION               NODE-CLASS
     ip-11-0-109-70.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801
     ip-11-0-148-55.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   test
     ip-11-0-186-88.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801
5. Get Arch, OS, Instance type and node type if kops (also works with EKS)
     ❯ kubectl get nodes -o wide -L beta.kubernetes.io/arch -L beta.kubernetes.io/os -L beta.kubernetes.io/instance-type -L  kops.k8s.io/instancegroup
     ❯ kubectl get nodes -L beta.kubernetes.io/arch -L beta.kubernetes.io/os -L beta.kubernetes.io/instance-type -L  kops.k8s.io/instancegroup
     NAME                                        STATUS   ROLES    AGE     VERSION               INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                  CONTAINER-RUNTIME   ARCH    OS      INSTANCE-TYPE   INSTANCEGROUP
     ip-11-0-109-70.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   11.0.109.70   <none>        Amazon Linux 2   4.14.209-160.335.amzn2.x86_64   docker://19.3.6     amd64   linux   m5.large
     ip-11-0-148-55.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   11.0.148.55   <none>        Amazon Linux 2   4.14.209-160.335.amzn2.x86_64   docker://19.3.6     amd64   linux   m5.large
     ip-11-0-186-88.eu-west-1.compute.internal   Ready    <none>   5d21h   v1.16.15-eks-ad4801   11.0.186.88   <none>        Amazon Linux 2   4.14.209-160.335.amzn2.x86_64   docker://19.3.6     amd64   linux   m5.large
6. Get node version and name only
     ❯ kubectl get nodes -o custom-columns=NAME:.metadata.name,VER:.status.nodeInfo.kubeletVersion
     NAME                                        VER
     ip-11-0-109-70.eu-west-1.compute.internal   v1.16.15-eks-ad4801
     ip-11-0-148-55.eu-west-1.compute.internal   v1.16.15-eks-ad4801
     ip-11-0-186-88.eu-west-1.compute.internal   v1.16.15-eks-ad4801
7. Get scheduleable nodes
     ❯ kubectl get nodes --output 'jsonpath={range $.items[*]}{.metadata.name} {.spec.taints[*].effect}{"\n"}{end}' | awk '!/NoSchedule/{print $1}'
     ip-11-0-109-70.eu-west-1.compute.internal
     ip-11-0-148-55.eu-west-1.compute.internal
     ip-11-0-186-88.eu-west-1.compute.internal
8. Get all deployments nameonly
     ❯ kubectl get deployment -o=jsonpath='{.items[*].metadata.name}'
     cluster-autoscaler-aws-cluster-autoscaler nginx-ingress-controller nginx-ingress-default-backend sealed-secrets
9. Get one deployment only (first one)
     ❯ kubectl get deployment -o=jsonpath='{.items[0].metadata.name}'
     cluster-autoscaler-aws-cluster-autoscaler
10. Get all pods statuses only
     ❯ kubectl get pods -o=jsonpath='{.items[*].status.phase}' --all-namespaces
     Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Pending Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running Running
11. Get pods qos
     ❯ kubectl get pods --all-namespaces -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,QOS-CLASS:.status.qosClass
     NAME                                                         NAMESPACE           QOS-CLASS
     cluster-autoscaler-aws-cluster-autoscaler-76b79d696f-gfj2z   admin               BestEffort
     nginx-ingress-controller-b594dbb8b-cl4gn                     admin               BestEffort
     nginx-ingress-default-backend-674d599c48-7nfmj               admin               BestEffort
     sealed-secrets-95c76d5d5-t786z                               admin               BestEffort
     cloudwatch-agent-4jl4h                                       amazon-cloudwatch   Guaranteed
     cloudwatch-agent-92rbq                                       amazon-cloudwatch   Guaranteed
     cloudwatch-agent-m8bv6                                       amazon-cloudwatch   Guaranteed
     fluentd-cloudwatch-5zs72                                     amazon-cloudwatch   Burstable
     fluentd-cloudwatch-9zsdh                                     amazon-cloudwatch   Burstable
     fluentd-cloudwatch-pq99b                                     amazon-cloudwatch   Burstable
     argocd-application-controller-d99d77688-xbqv5                argocd              BestEffort
     argocd-dex-server-6c865df778-k6rgt                           argocd              BestEffort
     argocd-redis-8c568b5db-2rqzg                                 argocd              BestEffort
     argocd-repo-server-675bddcbb8-vr46x                          argocd              BestEffort
     argocd-server-55685944cb-jmbwz                               argocd              BestEffort
     ghost-6dc5f59ccb-kt9cc                                       demo                Burstable
     ghost-mariadb-0                                              demo                BestEffort
     guestbook-ui-6796b99796-4v698                                demo                BestEffort
     mongodb-c7754bcf9-hf6qw                                      demo                BestEffort
     redis-master-0                                               demo                BestEffort
     weave-scope-agent-weave-scope-25z84                          demo                BestEffort
     weave-scope-agent-weave-scope-cwdmt                          demo                BestEffort
     weave-scope-agent-weave-scope-vb7wr                          demo                BestEffort
     weave-scope-cluster-agent-weave-scope-7c8b798d7b-m4hdb       demo                BestEffort
     weave-scope-frontend-weave-scope-66cfd495b5-cvmck            demo                BestEffort
     nginx-88f46754c-49gm6                                        example-app         Guaranteed
     grafana-69db6fb4d-lz57k                                      gotk-system         BestEffort
     helm-controller-7886cd4fdc-mdb8g                             gotk-system         Burstable
     kustomize-controller-5c8b54b7b6-q6tn4                        gotk-system         Burstable
     notification-controller-75cf575899-bh5q6                     gotk-system         Burstable
     prometheus-854d98f4d6-lljcn                                  gotk-system         Burstable
     source-controller-7db7bd4b5b-dzjcp                           gotk-system         Burstable
     chao-5d59df7bdc-vbk2w                                        gremlin             BestEffort
     gremlin-bgcdm                                                gremlin             BestEffort
     gremlin-fwqct                                                gremlin             BestEffort
     gremlin-mq2kh                                                gremlin             BestEffort
     aws-node-2wtc2                                               kube-system         Burstable
     aws-node-45965                                               kube-system         Burstable
     aws-node-77dvh                                               kube-system         Burstable
     coredns-6658f9f447-qn79n                                     kube-system         Burstable
     coredns-6658f9f447-sd8rh                                     kube-system         Burstable
     kube-proxy-7c274                                             kube-system         Burstable
     kube-proxy-99s26                                             kube-system         Burstable
     kube-proxy-zfmkp                                             kube-system         Burstable
     event-exporter-7fd4455f6f-fwkv4                              monitoring          BestEffort
     metrics-server-6b6bbf4668-77ftc                              monitoring          BestEffort
12. Get images running
     kubectl get pods --all-namespaces -o jsonpath="{..image}" |\
     tr -s '[[:space:]]' '\n' |\
     sort |\
     uniq -c
     6 602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon-k8s-cni:v1.6.1
     4 602401143452.dkr.ecr.eu-west-1.amazonaws.com/eks/coredns:v1.6.6
     6 602401143452.dkr.ecr.eu-west-1.amazonaws.com/eks/kube-proxy:v1.15.11
     6 amazon/cloudwatch-agent:1.247345.36b249270
     8 argoproj/argocd:v1.6.1
     1 bitnami/ghost:3.1.1-debian-9-r0
     1 bitnami/mariadb:10.3.22-debian-10-r27
     1 bitnami/redis:5.0.7
     6 busybox
     6 busybox:latest
     1 docker.io/bitnami/ghost:3.1.1-debian-9-r0
     1 docker.io/bitnami/mariadb:10.3.22-debian-10-r27
     2 docker.io/bitnami/mongodb:4.0.13
     1 docker.io/bitnami/redis:5.0.7
     6 fluent/fluentd-kubernetes-daemonset:v1.7.3-debian-cloudwatch-1.0
     2 gcr.io/heptio-images/ks-guestbook-demo:0.2
     2 ghcr.io/fluxcd/helm-controller:v0.1.3
     2 ghcr.io/fluxcd/kustomize-controller:v0.1.2
     2 ghcr.io/fluxcd/notification-controller:v0.1.2
     2 ghcr.io/fluxcd/source-controller:v0.1.1
     2 grafana/grafana:7.2.1
     2 gremlin/chao:latest
     6 gremlin/gremlin:latest
     2 k8s.gcr.io/cluster-autoscaler:v1.17.1
     2 k8s.gcr.io/defaultbackend-amd64:1.5
     2 k8s.gcr.io/metrics-server-amd64:v0.3.6
     1 nginx
     1 nginx:latest
     2 okteto/bin:1.1.20
     2 okteto/hello-world:node-dev
     2 opsgenie/kubernetes-event-exporter:0.7
     2 prom/prometheus:v2.21.0
     2 quay.io/bitnami/sealed-secrets-controller:v0.9.6
     2 quay.io/dexidp/dex:v2.22.0
     2 quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.32.0
     2 redis:5.0.3
     10 weaveworks/scope:1.12.0
13. Where is my pod running
     kubectl get pods -n sock-shop -l name=carts -o wide
14. Check node/pod usage memory and cpu
     kubectl top nodes
     kubectl top pods
15. Check health of etcd
     kubectl get --raw=/healthz/etcd
16. Check status of node autoscaler
     kubectl describe configmap cluster-autoscaler-status -n kube-system
17. Get where pods are running from nodenames
     ❯ kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces
     NAME                                                         STATUS    NODE
     cluster-autoscaler-aws-cluster-autoscaler-76b79d696f-gfj2z   Running   ip-11-0-148-55.eu-west-1.compute.internal
     nginx-ingress-controller-b594dbb8b-cl4gn                     Running   ip-11-0-148-55.eu-west-1.compute.internal
     nginx-ingress-default-backend-674d599c48-7nfmj               Running   ip-11-0-109-70.eu-west-1.compute.internal
     sealed-secrets-95c76d5d5-t786z                               Running   ip-11-0-148-55.eu-west-1.compute.internal
     Example sorting pods by nodeName:
     kubectl get pods -o wide --sort-by="{.spec.nodeName}"
     Example of getting pods on nodes using label filter:
     for n in $(kubectl get nodes -l your_label_key=your_label_value --no-headers | cut -d " " -f1); do 
          kubectl get pods --all-namespaces  --no-headers --field-selector spec.nodeName=${n} 
     done
     or by number of restarts
     kubectl get pods --sort-by="{.status.containerStatuses[:1].restartCount}"
     Example filtering by nodeName using — template flag:
     $ kubectl get nodes
     NAME                         STATUS                     AGE
     ip-254-0-90-30.ec2.internal   Ready                      2d
     ip-254-0-90-35.ec2.internal   Ready                      2d
     ip-254-0-90-50.ec2.internal   Ready,SchedulingDisabled   2d
     ip-254-0-91-60.ec2.internal   Ready                      2d
     ip-254-0-91-65.ec2.internal   Ready                      2d
     $ kubectl get pods --template '{{range .items}}{{if eq .spec.nodeName "ip-254-0-90-30.ec2.internal"}}{{.metadata.name}}{{"\n"}}{{end}}}{{end}}'
     filebeat-000
     app-0000
     node-exporter-0000
     prometheus-000
     
18. Check pods which are not Runnning
     kubectl get pods --field-selector=status.phase!=Running --all-namespaces
19. Sort Nodes by Role, Age and kubelet version
     kubectl get nodes --sort-by={.metadata.labels."kubernetes\.io\/role"}
     kubectl get node --sort-by={.status.nodeInfo.kubeletVersion}
     watch kubectl get node --sort-by={.status.nodeInfo.kubeletVersion}   
     watch "kubectl get nodes --sort-by={.metadata.labels.\"kubernetes\.io\/role\"}"
     kubectl get nodes --sort-by=".status.conditions[?(@.reason == 'KubeletReady' )].lastTransitionTime"
20. Query apiservers
     kubectl get --raw=/apis
     kubectl get --raw=/logs/kube-apiserver.log
21. Setup a deployment with limits and requests
     kubectl run ken-test --image=kenichishibata/docker-curl -i --tty --limits='cpu=50m,memory=128Mi' --requests='cpu=50m,memory=128Mi'
     kubectl delete deployment policy-blue 
22. Get events for an individual resource
     kubectl get event --field-selector=involvedObject.name =foo -w
23. Get apiresources
     Check for an api resources available, this should show your crd api endpoints as well
     kubectl api-resources
     kubectl api-versions
     Check apiservices added (registered)
     kubectl get apiservices.apiregistration.k8s.io
     kubectl get apiservices.apiregistration.k8s.io v1beta1.metrics.k8s.io -o yaml
     Check hpa (maybe because you have custom metrics enabled in prometheus)?
     kubectl get hpa
     kubectl get hpa --all-namespaces kubectl get --raw /apis/metrics.k8s.io
     Bonus: Stop using` — all-namespaces`
     kubectl get pods -A
     kubectl get pods --all-namespaces