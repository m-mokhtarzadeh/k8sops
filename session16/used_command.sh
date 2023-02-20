kubectl get node master -o yaml | grep taint -A 2

kubectl label node node1 zone=east
kubectl label node node1 zone-