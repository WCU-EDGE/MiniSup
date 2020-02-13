#!/bin/bash

echo "sshPasswordAuth.sh"

# Script will set SSH to allow password authentication, which allows non-Cloudlab
# users (LDAP users) to log into the supercomputer.  This will be run on the head node.

set -x

sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

sleep 5
sudo systemctl restart sshd
sleep 30
STARTOUTPUT=$(sudo systemctl status sshd)
STARTWORKED=$(echo $STARTOUTPUT | grep "Active: active (running)")
while [ -z "$STARTWORKED" ]; do
   sudo systemctl restart sshd
   sleep 300
   STARTOUTPUT=$(sudo systemctl status sshd)
   STARTWORKED=$(echo $STARTOUTPUT | grep "Active: active (running)")
done

echo "SSH server restarted."
