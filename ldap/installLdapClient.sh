!#/bin/bash

set -x

echo "clientLdap.sh"

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss-ldap libpam-ldap ldap-utils

echo 'debconf start'
export DEBIAN_FRONTEND=noninteractive
cat /local/repository/ldap/preseedWorker.deb | sudo debconf-set-selections
echo 'debconf end'

#sudo dpkg-reconfigure slapd
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure ldap-auth-config
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libpam-runtime

sudo sed -i 's/compat systemd/compat systemd ldap/g' /etc/nsswitch.conf
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
echo 'session optional pam_mkhomedir.so skel=/etc/skel umask=077' | sudo tee -a /etc/pam.d/common-session

sudo ufw allow ldap
