#!/bin/bash
set -x

### #!/bin/sh

echo 'nodeWorker.sh'

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss-ldap libpam-ldap ldap-utils

echo 'debconf start'
export DEBIAN_FRONTEND=noninteractive
cat /local/repository/preseedWorker.deb | sudo debconf-set-selections
echo 'debconf end'

#sudo dpkg-reconfigure slapd
sudo dpkg-reconfigure ldap-auth-config
sudo dpkg-reconfigure libpam-runtime

sudo sed -i 's/compat systemd/compat systemd ldap/g' /etc/nsswitch.conf
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
echo 'session optional pam_mkhomedir.so skel=/etc/skel umask=077' | sudo tee -a /etc/pam.d/common-session

sudo ufw allow ldap

sudo apt-get install -y nfs-common

#chkconfig nfs on
#service rpcbind start
#service nfs start

##mkdir /scratch
#sleep 600
#sudo mkdir /opt/shared
#sudo mkdir /software
#sudo mount 192.168.1.1:/home /home
#sudo mount 192.168.1.1:/opt /opt/shared
#sudo mount 192.168.1.1:/software /software
##sudo mount 192.168.1.1:/scratch /scratch
###mount -t nfs 192.168.1.1:/software /software
###mount -t nfs 192.168.1.2:/scratch /scratch

sudo mkdir /opt/shared
sudo mkdir /software
sudo mount 192.168.1.1:/home /home || true
# Cycle until we can mount home.
while [mount | grep home > /dev/null]; do
  sudo mount 192.168.1.1:/home /home || true
  sleep 60
done
sudo mount 192.168.1.1:/opt /opt/shared
sudo mount 192.168.1.1:/software /software

#while [ ! -d /software/flagdir ]
#do
#  sleep 30
#done

echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
source ~/.bashrc

#while [ ! -d /scratch/flagdir ]
#do
#  sleep 30
#done

echo "Done" >> /users/jk880380/clientdone.txt
