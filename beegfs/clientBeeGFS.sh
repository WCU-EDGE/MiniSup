#!/bin/sh

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

sudo wget -O /etc/apt/sources.list.d/beegfs-deb9.list https://www.beegfs.io/release/latest-stable/dists/beegfs-deb9.list
sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y beegfs-client beegfs-helperd beegfs-utils

/opt/beegfs/sbin/beegfs-setup-client -m beenode

sudo systemctl start beegfs-helperd
sudo systemctl start beegfs-client

sleep 180
sudo ln -s /mnt/beegfs /scratch

# Copy, if exists.
cp /local/repository/source/* /scratch || true
