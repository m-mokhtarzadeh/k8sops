kubectl set image deployment/server server=mohamadmokhtar/library:go-http-server-v2
kubectl apply -f 02-replicaset-example_02.yml
kubectl edit deployment server
kubectl patch deployment server --patch '{"spec": {"template": {"spec": {"containers": [{"image": "mohamadmokhtar/library:go-http-server-v3"}]}}}}'
kubectl rollout status deployment/server
kubectl rollout undo deployment/server
kubectl rollout undo deployment/server --to-revision=1