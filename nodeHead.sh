#!/bin/bash
set -x

echo 'nodeHead.sh'

# Install LDAP server
sudo /local/repository/ldap/installLdapHead.sh

# Install NFS server
sudo /local/repository/nfs/installNfsHead.sh $1 $2

mkdir /software/flagdir
