#!/bin/bash

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

echo 'clientBeeGFS.sh'

sudo cp /local/repository/beegfs/beegfs-deb8.list /etc/apt/sources.list.d/beegfs-deb8.list

sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y jq
sudo apt-get install -y beegfs-helperd beegfs-utils
sudo apt-get install -y beegfs-client

# Get the mgmt server from the JSON file.  sed trick to remove quotation marks from https://stackoverflow.com/questions/9733338/shell-script-remove-first-and-last-quote-from-a-variable
PFS_JSON_FILE=/local/repository/beegfs/pfs_servers.json
BEEGFS_MGMT_SVR_RAW=$(jq ".[] | select(.type == \"mgmt\") | .nodename" $PFS_JSON_FILE)
BEEGFS_MGMT_SERVER=$(sed -e 's/^"//' -e 's/"$//' <<<"$BEEGFS_MGMT_SVR_RAW")

# Point to the mgmt server.
sudo /opt/beegfs/sbin/beegfs-setup-client -m $BEEGFS_MGMT_SERVER

sudo systemctl start beegfs-helperd
sudo systemctl start beegfs-client

sudo ln -s /mnt/beegfs /scratch
sudo /local/repository/beegfs/createUserDirs.sh

## Moved to createUserDirs.sh
#sudo ln -s /mnt/beegfs /scratch
#sudo mkdir /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}')
#
## Copy the source files from the repository, if they exist.
#sudo cp /local/repository/source/* /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}') || true
#sudo chmod 755 /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}')/*
#
## Copy source files, if they exist
#cp /local/repository/source/* /scratch/$(echo $HOSTNAME | awk -F'.' '{print $1}') || true
