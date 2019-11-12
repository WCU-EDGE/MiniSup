#!/bin/bash

set -x

echo "installLdapClient.sh"

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss-ldap libpam-ldap ldap-utils

export DEBIAN_FRONTEND=noninteractive
cat /local/repository/ldap/preseedWorker.deb | sudo debconf-set-selections

sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure ldap-auth-config
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libpam-runtime

sudo cp -rf /local/repository/ldap/ldap.conf.client /etc/ldap.conf

sudo sed -i 's/compat systemd/compat systemd ldap/g' /etc/nsswitch.conf
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
echo 'session optional pam_mkhomedir.so skel=/etc/skel umask=077' | sudo tee -a /etc/pam.d/common-session

sudo ufw allow ldap
