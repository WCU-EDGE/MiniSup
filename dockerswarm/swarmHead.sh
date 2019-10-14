#!/bin/bash

# preseed
export DEBIAN_FRONTEND=noninteractive
sudo sh -c 'echo "libssl1.1 libraries/restart-without-asking boolean true" | debconf-set-selections'
sudo sh -c 'echo "libssl1.1:amd64 libraries/restart-without-asking boolean true" | debconf-set-selections'

# Install docker swarm
sudo apt-get update -y && sudo apt-get upgrade -y 
# Now reboot!
sudo apt-get install apt-transport-https software-properties-common ca-certificates -y 
wget https://download.docker.com/linux/ubuntu/gpg && sudo apt-key add gpg
sudo sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" >> /etc/apt/sources.list'
sudo apt-get update -y
sudo apt-get install docker-ce -y
sudo systemctl start docker && sudo systemctl enable docker
###sudo groupadd docker && sudo usermod -aG docker dockeruser

#Firewall
sudo ufw allow 2376/tcp && sudo ufw allow 7946/udp && sudo ufw allow 7946/tcp && sudo ufw allow 80/tcp && sudo ufw allow 2377/tcp && sudo ufw allow 4789/udp
#sudo ufw reload && sudo ufw enable
sudo systemctl restart docker

# Create docker swarm cluster
sudo docker swarm init --advertise-addr 192.168.1.1 | awk '/docker swarm join --token/ {print}' > swarmKey.txt

echo 'Done swarmHead.sh'
