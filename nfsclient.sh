#!/bin/sh

yum install -y nfs-utils nfs-utils-lib
chkconfig nfs on
sleep 30
service rpcbind start
sleep 30
service nfs start
sleep 30
mkdir /software
mkdir /scratch
sleep 600
#mount -t nfs 192.168.1.1:/users/jk880380/software /software
mount -t nfs 192.168.1.1:/software /software
mount -t nfs 192.168.1.2:/users/jk880380/scratch /scratch

while [ ! -d /software/flagdir ]
do
  sleep 30
done

echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
source /users/jk880380/.bashrc

#echo "Done" >> /users/jk880380/clientdone.txt
