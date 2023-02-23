#### install nerdctl ####
https://github.com/containerd/nerdctl
https://github.com/containerd/nerdctl/releases/download/v1.2.0/nerdctl-1.2.0-linux-amd64.tar.gz

kubectl cordon <node name>
kubectl drain <node name> --ignore-daemonsets

systemctl stop kubelet
systemctl stop docker

yum remove docker-ce docker-ce-cli

containerd config default > /etc/containerd/config.toml

systemctl restart containerd

# inside /var/lib/kubelet/kubeadm-flags.env
--container-runtime=remote 
--container-runtime-endpoint=unix:///run/containerd/containerd.sock

systemctl start kubelet

kubectl get nodes -o wide

kubectl uncordon <Node>
