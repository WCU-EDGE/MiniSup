#!/bin/bash

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

echo 'clientBeeGFS.sh'

set -x

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

# If the client service didn't start (meaning the server isn't live yet) then retry it until it does start
sleep 180
STARTOUTPUT=$(sudo systemctl status beegfs-client)
STARTWORKED=$(echo $STARTOUTPUT | grep "Active: active (exited)")
while [ -z "$STARTWORKED" ]; do
   sudo systemctl start beegfs-client
   sleep 180
   STARTOUTPUT=$(sudo systemctl status beegfs-client)
   STARTWORKED=$(echo $STARTOUTPUT | grep "Active: active (exited)")
done

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
