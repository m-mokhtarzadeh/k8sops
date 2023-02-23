dnf install haproxy

cat << EOF > /etc/haproxy/haproxy.cfg
listen stats 
        bind *:8080
        mode http
        stats enable
        stats hide-version
        stats show-legends
        stats refresh 5s
        stats realm Haproxy\ Statistics
        stats uri /stats
        stats auth admin:123
frontend kubeapi_front
        mode tcp
        option  tcplog
        bind :6443
        use_backend     kubeapi_back

backend kubeapi_back
        mode tcp
        server  master 192.168.2.251:6443 check
        server  master2 192.168.2.249:6443 check
        server  master3 192.168.2.248:6443 check
EOF

haproxy -c -f /etc/haproxy/haproxy.cfg

systemctl enable haproxy
systemctl start haproxy