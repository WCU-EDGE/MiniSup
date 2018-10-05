#!/bin/sh

yum install -y nfs-utils nfs-utils-lib
chkconfig nfs on
service rpcbind start
service nfs start
mkdir /scratch

#echo "/scratch 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.3(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.4(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.5(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.6(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.7(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.8(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.9(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.10(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.11(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.12(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.13(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
#echo "/scratch 192.168.1.14(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

# Create the permissions file for the NFS directory, and the machine list for MPI.
computes=$(($1 + 0))
for i in $(seq $computes)
do
  st='"/scratch 192.168.1.'
  st+=$(($i + 1))
  st+='(rw,sync,no_root_squash,no_subtree_check)'
  echo $st >> /etc/exports
  
  st2='192.168.1.'
  st2+=$(($i + 1))
  echo $st2 >> /scratch/machine_list
done

exportfs -a

sleep 600
mkdir /software
mount -t nfs 192.168.1.1:/software /software
#echo "Done" >> /users/jk880380/storagedoneNFS.txt

#fileNameList='/scratch/machine_list_'
#fileNameList+=$1
#cp /local/repository/source/* /scratch
#cp $fileNameList /scratch/machine_list

while [ ! -d /software/flagdir ]
do
  sleep 30
done

echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
source /users/jk880380/.bashrc

chmod 755 /scratch
mpicc /scratch/hello.c -o /scratch/hello
chmod 755 /scratch/hello

mkdir /scratch/flagdir

#echo "Done" >> /users/jk880380/storagedoneMPI.txt
