#!/bin/bash

set -x

echo "addpasswordless.sh"

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
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
for u in $USERNAMELIST 
do
    #if [ ! -f /users/$i/.ssh/id_rsa ]
    #then
    #   USER_GROUP=`id -gn ${i}`
    #
    #   sudo mkdir /home/$i || true
    #   sudo chown $i:$USER_GROUP /home/$i
    #   sudo touch /home/$i/.bashrc
    #   sudo chown $i:$USER_GROUP /home/$i/.bashrc
    #   echo "bash /local/repository/passwordless/passwordless.sh $1" | sudo tee -a /home/$i/.bashrc
    #   
    #   sudo mkdir /users/$i || true
    #   sudo chown $i:$USER_GROUP /users/$i
    #   sudo touch /users/$i/.bashrc
    #   sudo chown $i:$USER_GROUP /users/$i/.bashrc
    #   echo "bash /local/repository/passwordless/passwordless.sh $1" | sudo tee -a /users/$i/.bashrc
    #fi
    
    sudo -H -u $u bash -c "/local/repository/passwordless/passwordless.sh $1"
done
