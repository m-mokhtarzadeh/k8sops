kubectl config set-cluster <context name> \
--server=https://192.168.2.251:6443 \
--embed-certs \
--certificate-authority=path/to/the/cafile

kubectl config get-clusters
kubectl config get-contexts
kubectl config current-context

kubectl config set-credentials <user name> --token=<token> 
kubectl config set-context <context name> --namespace=<name space> --user=<user name> --cluster=< localadmin >
kubectl config use-context <context name>


---

git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
cat << EOF >> ~/.bashrc


#kubectx and kubens
export PATH=~/.kubectx:\$PATH
EOF