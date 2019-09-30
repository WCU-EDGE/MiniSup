#!/bin/bash
set -x

# debconf
sudo sh -c 'echo "libssl1.0.0	libssl1.0.0/restart-failed	error" | debconf-set-selections'
sudo sh -c 'echo "libssl1.0.0:amd64	libssl1.0.0/restart-failed	error	" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1	libraries/restart-without-asking	boolean	false" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1:amd64	libraries/restart-without-asking	boolean	false" | debconf-set-selections'
sudo sh -c 'echo "libssl1.0.0	libssl1.0.0/restart-services	string	" | debconf-set-selections'
sudo sh -c 'echo "libssl1.0.0:amd64	libssl1.0.0/restart-services	string	" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1	libssl1.1/restart-failed	error	" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1:amd64	libssl1.1/restart-failed	error	" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1       libssl1.1/restart-services      string  openvpn ssh ntp bind9 apache2" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1:amd64 libssl1.1/restart-services      string  openvpn ssh ntp bind9 apache2" | debconf-set-selections'

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common tmux
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
sudo apt-get install -y httping
sudo apt-get install -y jq


# the username needs to be changed
##sudo usermod -aG docker lngo
sudo usermod -aG docker jk880380
echo "Done" >> /users/jk880380/dockerDone.txt
