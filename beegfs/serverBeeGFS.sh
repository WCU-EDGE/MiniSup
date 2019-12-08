#!/bin/bash

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

echo 'serverBeeGFS.sh'

MY_NAME=$1
BGFS_MGMTD_SVR=$2
BGFS_META_SVR=$3
BGFS_META_NUMBER=$4
BGFS_STORAGE_SVR=$5
BGFS_STORAGE_NUMBER=$6

sudo wget -O /etc/apt/sources.list.d/beegfs-deb9.list https://www.beegfs.io/release/latest-stable/dists/beegfs-deb9.list
sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y beegfs-mgmtd
sudo apt-get install -y beegfs-meta
sudo apt-get install -y beegfs-storage
sudo apt-get install -y beegfs-client beegfs-helperd beegfs-utils

if [ $MY_NAME = $BGFS_MGMTD_SVR ]
then
   sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd
   sudo systemctl start beegfs-mgmtd
fi

if [ $MY_NAME = $BGFS_META_SVR ]
then
   sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s BGFS_META_NUMBER -m $MY_NAME
   sudo systemctl start beegfs-meta
fi

if [ $MY_NAME = $BGFS_STORAGE_SVR ]
then
   sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid1/beegfs_storage -s BGFS_STORAGE_NUMBER -i 301 -m $MY_NAME
   sudo systemctl start beegfs-storage
fi

#sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd
#sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s 2 -m pfs-$1
#sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid1/beegfs_storage -s 3 -i 301 -m pfs-$1
#
##sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s 2 -m pfs
##sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid1/beegfs_storage -s 3 -i 301 -m pfs

#sudo systemctl start beegfs-mgmtd
#sudo systemctl start beegfs-meta
#sudo systemctl start beegfs-storage
