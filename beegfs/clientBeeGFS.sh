#!/bin/bash

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

echo 'clientBeeGFS.sh'

#sudo wget -O /etc/apt/sources.list.d/beegfs-deb9.list https://www.beegfs.io/release/latest-stable/dists/beegfs-deb9.list

## The next line is the contents of the beegfs-deb8.list file from beegfs.io, which isn't always available for some reason.
#sudo sh -c "echo 'deb [arch=amd64] https://www.beegfs.io/release/beegfs_7_1 jessie non-free' >> /etc/apt/sources.list.d/beegfs-deb8.list"

sudo cp /local/repository/beegfs/beegfs-deb8.list /etc/apt/sources.list.d/beegfs-deb8.list

sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y beegfs-helperd beegfs-utils
sudo apt-get install -y beegfs-client
sudo /opt/beegfs/sbin/beegfs-setup-client -m beenode

sudo systemctl start beegfs-helperd
sudo systemctl start beegfs-client

sudo ln -s /mnt/beegfs /scratch
sudo mkdir /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}')

# Copy the source files from the repository, if they exist.
sudo cp /local/repository/source/* /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}') || true
sudo chmod 755 /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}')/*

# Copy source files, if they exist
cp /local/repository/source/* /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}') || true
