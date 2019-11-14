#!/bin.bash

set -x

echo 'installNfsHead.sh'

mkdir /software
sudo chown nobody:nogroup /software
sudo chown nobody:nogroup /home

sudo chmod -R a+rx /software
sudo chmod -R 777 /home
sudo chmod -R a+rx /opt

#################

sudo apt-get install -y nfs-kernel-server

# Create the permissions file for the NFS directory.
computes=$(($1 + 1))
for i in $(seq 2 $computes)
do
  echo "/home 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/opt 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/software 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  #echo "/scratch 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
done

# Let the Slurm node have access to the shared directories.
slurmip=$(($2 + 1))
echo "/home 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/opt 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/software 192.168.1.$slurmip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports

sudo systemctl restart nfs-kernel-server

#chkconfig nfs on
#service rpcbind start
#service nfs start
