#!/bin/bash

set -x

echo "installNfsClient.sh"

sudo apt-get update

sudo apt-get install -y nfs-common

sudo mkdir /mpishare
sudo mkdir /opt/shared
sudo mkdir /software

sudo mount 192.168.1.1:/software /software || true
# Cycle until we can mount software.
while [ ! -d /software/flagdir ]; do
  sudo mount 192.168.1.1:/software /software || true
  sleep 60
done
sudo mount 192.168.1.1:/home /home
sudo mount 192.168.1.1:/mpishare /mpishare
sudo mount 192.168.1.1:/opt /opt/shared

# Keep the shared dirs after a reboot
echo '192.168.1.1:/home /home nfs' | sudo tee -a /etc/fstab
echo '192.168.1.1:/mpishare /mpishare nfs' | sudo tee -a /etc/fstab
echo '192.168.1.1:/opt /opt/shared nfs' | sudo tee -a /etc/fstab
echo '192.168.1.1:/software /software nfs' | sudo tee -a /etc/fstab

# Change user home dirs
set +x
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
set -x
for i in $USERNAMELIST 
do
    sudo usermod -d /home/$i $i
done
