#!/bin/bash

echo "addpasswordless.sh"

USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')

set -x

# Get the per-experiment key, which cannot be accessed by the LDAP users.
while [ ! -d /software/flagdir ]; do
    sleep 60
done
SSHDIR=/software/geni-key
PRIVKEYNAME=geni-key.key
if [ ! -d $SSHDIR ]; then
    # Whoever gets to this code first makes the passkey.
    sudo mkdir $SSHDIR
    sudo chmod 755 $SSHDIR
    PRIVKEY="${SSHDIR}/${PRIVKEYNAME}"
    geni-get key > ${PRIVKEY}
    if [ ! $? -eq 0 -o ! -s ${PRIVKEY} ]; then
        echo "ERROR: Failed to retrieve per-experiment key.  SSH auto-connect will not work!"
        exit 1
    fi
fi

# The passwordless script must run for every user so put it in .bashrc.
for u in $USERNAMELIST 
do
    sudo usermod -a -G root $u
    sudo -H -u $u bash -c "/local/repository/passwordless/passwordless.sh $1"
done
