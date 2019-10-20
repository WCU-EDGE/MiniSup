#!/bin/sh

echo 'nfshead.sh'

apt-get install -y nfs-utils nfs-utils-lib
#yum install -y nfs-utils nfs-utils-lib
chkconfig nfs on
service rpcbind start
service nfs start
mkdir /software

# Create the permissions file for the NFS directory.
computes=$(($1 + 1))
for i in $(seq $computes)
do
  st='/software 192.168.1.'
  st+=$(($i))
  st+='(rw,sync,no_root_squash,no_subtree_check)'
  echo $st >> /etc/exports
done

#echo "/software 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.3(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.4(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.5(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.6(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.7(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.8(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.9(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.10(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.11(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.12(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.13(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/software 192.168.1.14(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

exportfs -a
echo "Done" >> /users/jk880380/headdoneNFS.txt

set -x
#sudo yum -y group install "Development Tools"
sudo apt-get -y group install "Development Tools"
cd /software
sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
sudo tar xzf openmpi-3.1.2.tar.gz
cd openmpi-3.1.2
sudo ./configure --prefix=/software
sudo make
sudo make all install
echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz
mkdir /software/flagdir
echo "Done" >> /users/jk880380/headdoneMPI.txt
