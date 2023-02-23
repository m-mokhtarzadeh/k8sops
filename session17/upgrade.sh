kubeadm version
kubeadm upgrade plan
sudo kubeadm upgrade apply <version>
kubectl drain <node> --ignore-daemonsets

sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubectl uncordon <node-to-uncordon>

----
sudo kubeadm upgrade node
kubectl drain <node name> --ignore-daemonsets
sudo systemctl daemon-reload
sudo systemctl restart kubelet

----
kubectl get nodes
