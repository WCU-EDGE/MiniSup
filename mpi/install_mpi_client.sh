#!/bin/bash

set -x

echo "install_mpi_client.sh"

# We run MPI using the network installation, so we only need to add that to our path(s). Make sure all users
#  have this in their path(s).
echo 'export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin' | sudo tee -a /etc/skel/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/shared/openmpi/3.1.2/lib/' | sudo tee -a /etc/skel/.bashrc

# Add openmpi bin and library to path for everyone.
sudo sed -i '/^PATH/ s/\"$/\:\/opt\/shared\/openmpi\/3.1.2\/bin\"/g' /etc/environment
echo 'export LD_LIBRARY_PATH=/opt/shared/openmpi/3.1.2/lib/' | sudo tee -a /etc/environment

# Set path right now.
export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin
export LD_LIBRARY_PATH=/opt/shared/openmpi/3.1.2/lib/
