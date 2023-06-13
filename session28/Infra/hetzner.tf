locals {
  cloud_init = <<EOF
#cloud-config
users:
  - name: rocky
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - '${tls_private_key.k8sops_key.public_key_openssh}'
yum_repos:
  kubernetes:
    name: Kubernetes
    baseurl: 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch'
    enabled: true
    gpgcheck: true
    gpgkey: 'https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'
  docker:
    name: Docker CE Stable - $basearch
    baseurl: 'https://download.docker.com/linux/centos/$releasever/$basearch/stable'
    enabled: true
    gpgcheck: true
    gpgkey: 'https://download.docker.com/linux/centos/gpg'
packages:
 - containerd.io
 - kubectl-1.24.10
 - kubelet-1.24.10
 - kubeadm-1.24.10
package_update: false
package_upgrade: false
runcmd:
  - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -e '/^#PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -e '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i -e '/^#PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i -e '/^Port/s/^.*$/Port 22000/' /etc/ssh/sshd_config
  - sed -i -e '/^#Port/s/^.*$/Port 22000/' /etc/ssh/sshd_config
  - reboot
  EOF
}

resource "tls_private_key" "k8sops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "k8sops" {
  name       = "k8sops"
  public_key = tls_private_key.k8sops_key.public_key_openssh
}

resource "hcloud_placement_group" "k8sops" {
  name = "k8sops"
  type = "spread"
}

## Master
resource "hcloud_primary_ip" "k8sops_master" {
  name          = "k8sops-master"
  datacenter    = var.server_location
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}

resource "hcloud_server" "k8sops_master" {
  name        = "k8sops-master"
  datacenter  = var.server_location
  image       = "rocky-8"
  server_type = "cpx31"
  user_data   = local.cloud_init
  ssh_keys    = [hcloud_ssh_key.k8sops.name]
	placement_group_id = hcloud_placement_group.k8sops.id
  public_net {
    ipv4         = hcloud_primary_ip.k8sops_master.id
    ipv6_enabled = false
  }
}

## Worker1
resource "hcloud_primary_ip" "k8sops_worker_1" {
  name          = "k8sops-worker-1"
  datacenter    = var.server_location
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}

resource "hcloud_server" "k8sops_worker_1" {
	depends_on = [ 
		hcloud_server.k8sops_master
	]
  name        = "k8sops-worker-1"
  datacenter  = var.server_location
  image       = "rocky-8"
  server_type = "cpx31"
  user_data   = local.cloud_init
  ssh_keys    = [hcloud_ssh_key.k8sops.name]
	placement_group_id = hcloud_placement_group.k8sops.id
  public_net {
    ipv4         = hcloud_primary_ip.k8sops_worker_1.id
    ipv6_enabled = false
  }
}

## Worker2
resource "hcloud_primary_ip" "k8sops_worker_2" {
  name          = "k8sops-worker-2"
  datacenter    = var.server_location
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}

resource "hcloud_server" "k8sops_worker_2" {
	depends_on = [ 
		hcloud_server.k8sops_worker_1
	]
  name        = "k8sops-worker-2"
  datacenter  = var.server_location
  image       = "rocky-8"
  server_type = "cpx31"
  user_data   = local.cloud_init
  ssh_keys    = [hcloud_ssh_key.k8sops.name]
	placement_group_id = hcloud_placement_group.k8sops.id
  public_net {
    ipv4         = hcloud_primary_ip.k8sops_worker_2.id
    ipv6_enabled = false
  }
}


resource "hcloud_network" "k8sops" {
  name     = "k8sops"
  ip_range = "192.168.0.0/16"
}
resource "hcloud_network_subnet" "k8sops" {
  network_id   = hcloud_network.k8sops.id
  type         = "cloud"
  network_zone = "us-east"
  ip_range     = "192.168.2.0/24"
}

resource "hcloud_server_network" "k8sops_master" {
  server_id  = hcloud_server.k8sops_master.id
  network_id = hcloud_network.k8sops.id
  ip         = "192.168.2.251"
}

resource "hcloud_server_network" "k8sops_worker_1" {
  server_id  = hcloud_server.k8sops_worker_1.id
  network_id = hcloud_network.k8sops.id
  ip         = "192.168.2.252"
}

resource "hcloud_server_network" "k8sops_worker_2" {
  server_id  = hcloud_server.k8sops_worker_2.id
  network_id = hcloud_network.k8sops.id
  ip         = "192.168.2.253"
}


output "k8sops_sshkey" {
  value = tls_private_key.k8sops_key.private_key_openssh
	sensitive = true
}

output "k8sops_master" {
  value = [ hcloud_server.k8sops_master.ipv4_address, hcloud_server_network.k8sops_master.ip ]
}

output "k8sops_worker_1" {
  value = [ hcloud_server.k8sops_worker_1.ipv4_address, hcloud_server_network.k8sops_worker_1.ip ]
}

output "k8sops_worker_2" {
  value = [ hcloud_server.k8sops_worker_2.ipv4_address, hcloud_server_network.k8sops_worker_2.ip ]
}