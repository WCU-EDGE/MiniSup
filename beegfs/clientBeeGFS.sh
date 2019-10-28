#!/bin/bash

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

echo 'clientBeeGFS.sh'

sudo wget -O /etc/apt/sources.list.d/beegfs-deb9.list https://www.beegfs.io/release/latest-stable/dists/beegfs-deb9.list
sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y beegfs-client beegfs-helperd beegfs-utils

sudo /opt/beegfs/sbin/beegfs-setup-client -m beenode

sudo systemctl start beegfs-helperd
sudo systemctl start beegfs-client

sleep 180
#LOCALHOSTNAME=$(echo $HOSTNAME | awk -F'.' '{print $1}')
#sudo ln -s /mnt/beegfs /scratch
#sudo mkdir /scratch/$LOCALHOSTNAME

sudo ln -s /mnt/beegfs /scratch
sudo mkdir /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}')

# Copy, if exists.
#cp /local/repository/source/* /scratch/$LOCALHOSTNAME || true
sudo cp /local/repository/source/* /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}') || true
