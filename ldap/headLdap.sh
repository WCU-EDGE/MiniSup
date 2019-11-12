#!/bin/bash

set -x

## Install LDAP head node

sudo apt-get update
sudo apt-get install -y debconf-utils

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

# debconf
echo 'debconf start'
export DEBIAN_FRONTEND=noninteractive
#sudo sh -c 'cat /local/repository/preseedHead.deb | debconf-set-selections'
cat /local/repository/preseedHead.deb | sudo debconf-set-selections
#sudo debconf-set-selections <<< 'slapd slapd/root_password password admin'
#sudo debconf-set-selections <<< 'slapd slapd/root_password_again password admin'
#sudo debconf-set-selections <<< 'slapd slapd/internal/generated_adminpw password admin'
#sudo debconf-set-selections <<< 'slapd slapd/internal/adminpw password admin'
#sudo debconf-set-selections <<< 'slapd slapd/password1 password admin'
#sudo debconf-set-selections <<< 'slapd slapd/password2 password admin'
echo 'debconf end'

#sudo DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

#sudo /local/repository/ldap/configLdap.sh


#sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure slapd
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure slapd
sudo ufw allow ldap
