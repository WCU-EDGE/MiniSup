#!/bin/bash
set -x

echo 'nodeHead.sh'

# Install LDAP server
sudo /local/repository/ldap/installLdapHead.sh

# Install LDAP client so we can run MPI as LDAP users
sudo /local/repository/ldap/installLdapClient.sh

# Install NFS server
sudo /local/repository/nfs/installNfsHead.sh $1 $2

mkdir /software/flagdir
