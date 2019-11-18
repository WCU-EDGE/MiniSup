#!/bin/bash

set -x

echo "install_mpi_client.sh"

PATH=$PATH:/software/mpiexec/bin

# We run MPI using the network installation, so we need to add that to our path(s). Make sure all users
#  have this in their path(s).
echo 'export PATH=$PATH:/software/mpiexec/bin' | sudo tee -a /etc/skel/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/mpiexec/lib/' | sudo tee -a /etc/skel/.bashrc

# Everyone should look to the openmpi binaries.
sudo sed -i '/^PATH/ s/\"$/\:\/software\/mpiexec\/bin\"/g' /etc/environment

# Guarantee LD_LIBRARY_PATH isn't empty, so we don't have a leading colon in it during a later export (which
#  would lead to a security hole where Linux first searches the current directory for libraries!)
echo 'export LD_LIBRARY_PATH=/software/mpiexec/lib/' | sudo tee -a /etc/environment

# Set path right now.
export PATH=$PATH:/software/mpiexec/bin
export LD_LIBRARY_PATH=/software/mpiexec/lib/

# Make sure everyone picks up the paths!
set +x
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
set -x
for i in $USERNAMELIST 
do
    sudo mkdir /home/$i || true
    sudo chown $i /home/$i
    sudo touch /home/$i/.bashrc
    echo 'export PATH=$PATH:/software/mpiexec/bin' | sudo tee -a /home/$i/.bashrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/mpiexec/lib/' | sudo tee -a /home/$i/.bashrc
    sudo mkdir /users/$i || true
    sudo chown $i /users/$i
    sudo touch /users/$i/.bashrc
    echo 'export PATH=$PATH:/software/mpiexec/bin' | sudo tee -a /users/$i/.bashrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/mpiexec/lib/' | sudo tee -a /users/$i/.bashrc
done

#########

## We run MPI using the network installation, so we only need to add that to our path(s). Make sure all users
##  have this in their path(s).
#echo 'export PATH=$PATH:/software/openmpi/3.1.2/bin' | sudo tee -a /etc/skel/.bashrc
##echo 'export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin' | sudo tee -a /etc/skel/.bashrc
#echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/' | sudo tee -a /etc/skel/.bashrc
#
## Add openmpi bin and library to path for everyone.
#sudo sed -i '/^PATH/ s/\"$/\:\/software\/openmpi\/3.1.2\/bin\"/g' /etc/environment
#echo 'LD_LIBRARY_PATH=/software/openmpi/3.1.2/lib/' | sudo tee -a /etc/environment
#
## Set path right now.
#export PATH=$PATH:/software/openmpi/3.1.2/bin
#export LD_LIBRARY_PATH=/software/openmpi/3.1.2/lib/
