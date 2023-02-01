#### nfs server
sudo dnf install -y nfs-utils
sudo mkdir /nfs-share
sudo chmod -R 777 /nfs-share
echo "/nfs-share  192.168.2.252(rw)" | sudo tee -a /etc/exports > /dev/null
echo "/nfs-share  192.168.2.253(rw)" | sudo tee -a /etc/exports > /dev/null
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
sudo systemctl enable --now nfs-server
showmount -e

#### nfs client
sudo dnf install -y nfs-utils