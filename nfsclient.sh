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
sleep 300
mount -t nfs 192.168.1.1:/users/jk880380/software /software
mount -t nfs 192.168.1.2:/users/jk880380/scratch /scratch
