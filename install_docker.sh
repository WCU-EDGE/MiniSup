#!/bin/bash
set -x
sudo apt-get update
echo "Done" >> /users/jk880380/dockerProcess01.txt
sudo apt-get remove -y --purge man-db
echo "Done" >> /users/jk880380/dockerProcess02.txt
sudo apt-get install -y apt-transport-https
echo "Done" >> /users/jk880380/dockerProcess02A.txt
sudo apt-get install -y ca-certificates
echo "Done" >> /users/jk880380/dockerProcess02B.txt
sudo apt-get install -y curl
echo "Done" >> /users/jk880380/dockerProcess02C.txt
sudo apt-get install -y gnupg-agent
echo "Done" >> /users/jk880380/dockerProcess02D.txt
sudo apt-get install -y software-properties-common
echo "Done" >> /users/jk880380/dockerProcess02E.txt
sudo apt-get install -y tmux
#sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common tmux
echo "Done" >> /users/jk880380/dockerProcess03.txt
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo "Done" >> /users/jk880380/dockerProcess04.txt
sudo apt-get update
echo "Done" >> /users/jk880380/dockerProcess05.txt
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
echo "Done" >> /users/jk880380/dockerProcess06.txt
sudo apt-get install -y httping
echo "Done" >> /users/jk880380/dockerProcess07.txt
sudo apt-get install -y jq
echo "Done" >> /users/jk880380/dockerProcess08.txt

# the username needs to be changed
##sudo usermod -aG docker lngo
sudo usermod -aG docker jk880380
echo "Done" >> /users/jk880380/dockerDone.txt
