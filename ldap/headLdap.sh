#!/bin/bash

set -x

## Install LDAP head node

echo "headLdap.sh"

# Installation
sudo apt-get update
sudo apt-get install -y debconf-utils
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

# debconf preseeding (must do AFTER the install or some fields get overwritten)
export DEBIAN_FRONTEND=noninteractive
cat /local/repository/ldap/preseedHead.deb | sudo debconf-set-selections

# Reconfigure
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure slapd
sudo ufw allow ldap

# Configure ldap
sudo /local/repository/ldap/createUsersLdif.sh
sudo ldapadd -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -w admin -f /local/repository/ldap/basedln.ldif
sudo ldapadd -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -w admin -f /local/repository/ldap/users.ldif
