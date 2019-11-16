#!/bin/bash

set -x

echo "addpasswordless.sh"

# The passwordless script must run for every user so put it in .bashrc.
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
for i in $USERNAMELIST 
do
    if [ ! -f /users/$i/.ssh/id_rsa ]
    then
       sudo mkdir /home/$i || true
       sudo chown $i /home/$i
       sudo touch /home/$i/.bashrc
       echo '/local/repository/passwordless/passwordless.sh' | sudo tee -a /home/$i/.bashrc
       sudo mkdir /users/$i || true
       sudo chown $i /users/$i
       sudo touch /users/$i/.bashrc
       echo '/local/repository/passwordless/passwordless.sh' | sudo tee -a /users/$i/.bashrc
    fi
done
