#!/bin/sh

yum install -y nfs-utils nfs-utils-lib
chkconfig nfs on
service rpcbind start
service nfs start
mkdir /software
mkdir /scratch
mount -t nfs 192.168.1.1:/users/jk880380/software /software
mount -t nfs 192.168.1.2:/users/jk880380/scratch /scratch
