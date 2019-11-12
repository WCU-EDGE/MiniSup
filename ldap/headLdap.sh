#!/bin/bash

set -x

## Install LDAP head node

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
