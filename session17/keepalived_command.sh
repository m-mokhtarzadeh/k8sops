dnf install gcc kernel-devel kernel-headers keepalived

cat << EOF > /etc/sysctl.d/99-keepalived.conf
net.ipv4.ip_nonlocal_bind = 1
EOF

sysctl --system

cat << EOF > /etc/keepalived/keepalived.conf
global_defs {
  notification_email {
    info@k8sops.ir
  }
  notification_email_from info@k8sops.ir
  smtp_connect_timeout 30
  router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s8
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.2.245/24
    }
}

EOF


cat << EOF > /etc/keepalived/keepalived.conf
global_defs {
  notification_email {
    info@k8sops.ir
  }
  notification_email_from info@k8sops.ir
  smtp_connect_timeout 30
  router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    state BACKUP
    interface enp0s8
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.2.245/24
    }
}

EOF
