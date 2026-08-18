#!/usr/bin/bash

rm /etc/netplan/50-cloud-init.yaml
touch /etc/netplan/99-goad-network.yaml
chmod 600 /etc/netplan/99-goad-network.yaml
cat > /etc/netplan/99-goad-network.yaml<< EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
    eth1:
      dhcp4: false
      addresses:
        - $1/24
EOF
nohup bash -c "sleep 2 && netplan apply" > /dev/null 2>&1 &