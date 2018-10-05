#!/bin/sh

yum install -y nfs-utils nfs-utils-lib
chkconfig nfs on
service rpcbind start
service nfs start
mkdir /users/jk880380/software
echo "/users/jk880380/software 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.3(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.4(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.5(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.6(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.7(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.8(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.9(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.10(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.11(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/users/jk880380/software 192.168.1.12(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
exportfs -a
echo "Done" >> /users/jk880380/headdoneNFS.txt
set -x
sudo yum -y group install "Development Tools"
cd /users/jk880380/software
sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
sudo tar xzf openmpi-3.1.2.tar.gz
cd openmpi-3.1.2
#sudo ./configure --prefix=/opt/openmpi/3.1.2
sudo ./configure --prefix=/users/jk880380/software
sudo make
sudo make all install
echo "export PATH='$PATH:/users/jk880380/software/bin'" >> /users/jk880380/.bashrc
#echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/opt/openmpi/3.1.2/lib/'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/users/jk880380/software/lib/'" >> /users/jk880380/.bashrc
cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz
mkdir /users/jk880380/software/flagdir
echo "Done" >> /users/jk880380/headdoneMPI.txt
