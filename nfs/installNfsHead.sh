#!/bin/bash

set -x

echo 'installNfsHead.sh'

mkdir /mpishare
mkdir /software

sudo chown nobody:nogroup /home
sudo chown nobody:nogroup /mpishare
sudo chown nobody:nogroup /opt
sudo chown nobody:nogroup /software

sudo chmod -R 777 /home
sudo chmod -R 777 /mpishare
sudo chmod -R a+rx /opt
sudo chmod -R a+rx /software

#################

# Change user home dirs
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
for i in $USERNAMELIST 
do
    USER_GROUP=`id -gn ${i}`
    sudo usermod -m -d /home/$i $i
    sudo chown $i:$USER_GROUP /home/$i
done

sudo apt-get install -y nfs-kernel-server

# Create the permissions file for the NFS directory.
computes=$(($1 + 1))
for i in $(seq 2 $computes)
do
  echo "/home 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/mpishare 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/opt 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/software 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
done

# Let the Slurm node have access to the shared directories.
slurmip=$(($2 + 1))
echo "/home 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/mpishare 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/opt 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/software 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports

# Let the login node have access to the shared directories.
loginip=$(($3 + 1))
echo "/home 192.168.1.$loginip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/mpishare 192.168.1.$loginip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/opt 192.168.1.$loginip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/software 192.168.1.$loginip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports

sudo systemctl restart nfs-kernel-server
