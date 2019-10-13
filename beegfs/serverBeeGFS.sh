# https://www.beegfs.io/wiki/ManualInstallWalkThrough

### Name the machine beenode

sudo wget -O /etc/apt/sources.list.d/beegfs-deb9.list https://www.beegfs.io/release/latest-stable/dists/beegfs-deb9.list
sudo wget -q https://www.beegfs.io/release/latest-stable/gpg/DEB-GPG-KEY-beegfs -O- | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install -y beegfs-mgmtd
sudo apt-get install -y beegfs-meta
sudo apt-get install -y beegfs-storage
sudo apt-get install -y beegfs-client beegfs-helperd beegfs-utils

sudo /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd
sudo /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta -s 2 -m beenode
sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/myraid1/beegfs_storage -s 3 -i 301 -m beenode

sudo systemctl start beegfs-mgmtd
sudo systemctl start beegfs-meta
sudo systemctl start beegfs-storage
