kubectl -n kube-system get configmap kubeadm-config -o jsonpath='{.data.ClusterConfiguration}' > kubeadm.yaml

####
    apiServer:
      certSANs:
      - 192.168.2.251 # master --- > master1
      - 192.168.2.249 # master2
      - 192.168.2.248 # master3
      - 192.168.2.245 # VIP ---> floatip
      - cluster.local
      extraArgs:
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta3
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controlPlaneEndpoint: 192.168.2.251:6443
    controllerManager: {}
    dns: {}
    etcd:
      local:
        serverCertSANs:
         - 192.168.2.251
         - master
         - 192.168.2.249
         - master2
         - 192.168.2.248
         - master3
        peerCertSANs:
         - 192.168.2.251
         - master
         - 192.168.2.249
         - master2
         - 192.168.2.248
         - master3
        dataDir: /var/lib/etcd
    imageRepository: registry.mmokhtar.ir/library
    kind: ClusterConfiguration
    kubernetesVersion: v1.24.10
    networking:
      dnsDomain: cluster.local
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
####

kubeadm init phase certs apiserver --config kubeadm.yaml
kubeadm init phase certs etcd-server --config kubeadm.yaml
kubeadm init phase certs etcd-peer --config kubeadm.yaml
kubeadm config upload from-file --config kubeadm.yaml
kubectl -n kube-system get configmap kubeadm-config -o yaml

----
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/
kubeadm certs check-expiration
