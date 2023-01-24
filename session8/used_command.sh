docker pull mohamadmokhtar/library:monitor
docker save mohamadmokhtar/library:monitor > monitor
docker load < monitor

-------

kubectl label node < node name > disk-type=hdd

-------

docker pull mohamadmokhtar/library:count
docker save mohamadmokhtar/library:count | gzip > count.gz
zcat count.gz | docker load

-------

kubectl get jobs
kubectl get cronjobs