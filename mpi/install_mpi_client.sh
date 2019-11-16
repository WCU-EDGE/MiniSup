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
