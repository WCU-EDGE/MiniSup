#!/bin/sh

set -x

##
## This script creates an SSH keypair for a given user on a node in a
## Cloudlab experiment, and adds it to that user's SSH authorized_keys
## file.  If run with the same user configuration on each node in the
## same experiment, it will generate the same keypair, because it uses a
## per-experiment shared secret (a private key) downloaded from the
## Cloudlab management servers.  Only your experiment has access to this
## key.  This allows the given user to login via SSH from any node in
## your experiment to any other node in your experiment.
##

#
# A simple configuration for the root user.  Change KEYNAME as desired.
#

KEYNAME=id_rsa

#
# We don't overwrite existing keys by default, unless you set FORCE=1.
#
FORCE=1

#
# Set some other vars for convenience.
#
SSHDIR=~/.ssh
PRIVKEY="${SSHDIR}/${KEYNAME}"
PUBKEY="${SSHDIR}/${KEYNAME}.pub"

# Don't run this more than once.
if [ -f "${SSHDIR}/passwordlessran.flg" ]
then
   exit 0
fi

#
# Don't overwrite existing keys unless forced to do so.
#
if [ $FORCE -eq 0 -a \( -e $PRIVKEY -o -e $PUBKEY \) ]; then
    echo "ERROR: not overwriting existing $PRIVKEY $PUBKEY files; aborting!"
    exit 1
fi

##
## Create .ssh dir with appropriate permissions.
##
#mkdir -p $SSHDIR
#chown -R $USER:$USER $SSHDIR

##
## Get the per-experiment shared key from the Cloudlab management API.
##
#geni-get key > ${PRIVKEY}.tmp
#if [ ! $? -eq 0 -o ! -s ${PRIVKEY}.tmp ]; then
#    echo "ERROR: failed to retrieve per-experiment key!"
#    exit 1
#fi

# Get the per-experiment key saved by addpasswordless.sh
SAVEDKEYDIR=/software/geni-key
PRIVKEYNAME=geni-key.key
SAVEDPRIVKEY="${SAVEDKEYDIR}/${PRIVKEYNAME}"
sudo cp $SAVEDPRIVKEY ${PRIVKEY}.tmp
USER_GROUP=`id -gn ${USER}`
sudo chown $USER:$USER_GROUP ${PRIVKEY}.tmp

#
# Ensure correct, minimal permissions for ssh.
#
chmod 600 ${PRIVKEY}.tmp

#
# Generate a public key that corresponds to the private key half.
#
ssh-keygen -f ${PRIVKEY}.tmp -y > ${PUBKEY}.tmp
chmod 600 ${PUBKEY}.tmp

#
# Move the tmp key into place; will overwrite existing keys!
#
mv ${PRIVKEY}.tmp $PRIVKEY
mv ${PUBKEY}.tmp $PUBKEY

#
# Append the new pubkey to our authorized_keys so that other nodes that
# are generating the same keypair can login to us.  Ensure correct
# minimal permissions necessary for ssh.
#
touch $SSHDIR/authorized_keys
cat $PUBKEY >> $SSHDIR/authorized_keys
chmod 600 $SSHDIR/authorized_keys

# Force to add to known_hosts
for i in $(seq 1 $1)
do
  ssh -o StrictHostKeyChecking=no worker-$i ls
done
ssh -o StrictHostKeyChecking=no head ls

#touch "${SSHDIR}/passwordlessran.flg" 
