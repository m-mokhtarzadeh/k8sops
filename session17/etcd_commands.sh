# https://github.com/etcd-io/etcd/releases/

wget https://github.com/etcd-io/etcd/releases/download/v3.5.7/etcd-v3.5.7-linux-amd64.tar.gz

tar xf etcd-v3.5.7-linux-amd64.tar.gz
cd etcd-v3.5.7-linux-amd64

./etcdctl \
--endpoints=https://127.0.0.1:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save snapshot.db

./etcdctl --write-out=table snapshot status ./snapshot.db

./etcdutl --data-dir ./data snapshot restore ./snapshot.db