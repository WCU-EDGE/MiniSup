#!/bin/bash

# https://www.beegfs.io/wiki/ManualInstallWalkThrough

echo 'serverBeeGFS.sh'

set -x

sudo wget -O /etc/apt/sources.list.d/beegfs-deb9.list https://www.beegfs.io/release/latest-stable/dists/beegfs-deb9.list
sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y jq
sudo apt-get install -y beegfs-mgmtd
sudo apt-get install -y beegfs-meta
sudo apt-get install -y beegfs-storage
sudo apt-get install -y beegfs-client beegfs-helperd beegfs-utils

# We will read the parallel file system info from a JSON file
MY_NAME=$1
PFS_JSON_FILE=/local/repository/beegfs/pfs_servers.json

IS_STORAGE=$(jq ".[] | select(.nodename == \"$MY_NAME\") | select(.type == \"storage\")" $PFS_JSON_FILE)
IS_META=$(jq ".[] | select(.nodename == \"$MY_NAME\") | select(.type == \"meta\")" $PFS_JSON_FILE)
IS_MGMT=$(jq ".[] | select(.nodename == \"$MY_NAME\") | select(.type == \"mgmt\")" $PFS_JSON_FILE)

BEEGFS_MGMT_SVR_RAW=$(jq ".[] | select(.type == \"mgmt\") | .nodename" $PFS_JSON_FILE)
BEEGFS_MGMT_SERVER=$(sed -e 's/^"//' -e 's/"$//' <<<"$BEEGFS_MGMT_SVR_RAW")

if [[ $IS_MGMT != "" ]]
then
  sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd
  sudo systemctl start beegfs-mgmtd
fi

if [[ $IS_META != "" ]]
then
   sleep 180
   SERVICE_ID=$(jq ".[] | select(.nodename == \"$MY_NAME\") | select(.type == \"meta\") | .serviceID" $PFS_JSON_FILE)
   sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s $SERVICE_ID -m $BEEGFS_MGMT_SERVER
   sudo systemctl start beegfs-meta
fi

if [[ $IS_STORAGE != "" ]]
then
   sleep 180
   SERVICE_ID=$(jq ".[] | select(.nodename == \"$MY_NAME\") | select(.type == \"storage\") | .serviceID" $PFS_JSON_FILE)
   STORAGE_TARGET_ID=$(jq ".[] | select(.nodename == \"$MY_NAME\") | select(.type == \"storage\") | .storagetarget" $PFS_JSON_FILE)
   sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid$SERVICE_ID/beegfs_storage -s $SERVICE_ID -i $STORAGE_TARGET_ID -m $BEEGFS_MGMT_SERVER
   sudo systemctl start beegfs-storage
fi


#sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd
#sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s 2 -m pfs-$1
#sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid1/beegfs_storage -s 3 -i 301 -m pfs-$1
#
##sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s 2 -m pfs
##sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid1/beegfs_storage -s 3 -i 301 -m pfs
#
#sudo systemctl start beegfs-mgmtd
#sudo systemctl start beegfs-meta
#sudo systemctl start beegfs-storage
