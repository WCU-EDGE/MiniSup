#!/bin/bash

set -x

echo "addpasswordless.sh"

# The passwordless script must run for every user so put it in .bashrc.
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
for i in $USERNAMELIST 
do
    if [ ! -f /users/$i/.ssh/id_rsa ]
    then
       USER_GROUP=`id -gn ${i}`
       sudo mkdir /home/$i || true
       sudo chown $i:$USER_GROUP /home/$i
       sudo touch /home/$i/.bashrc
       sudo chown $i:$USER_GROUP /home/$i/.bashrc
       echo "bash /local/repository/passwordless/passwordless.sh $1" | sudo tee -a /home/$i/.bashrc
       sudo mkdir /users/$i || true
       sudo chown $i:$USER_GROUP /users/$i
       sudo touch /users/$i/.bashrc
       sudo chown $i:$USER_GROUP /users/$i/.bashrc
       echo "bash /local/repository/passwordless/passwordless.sh $1" | sudo tee -a /users/$i/.bashrc
    fi
done
