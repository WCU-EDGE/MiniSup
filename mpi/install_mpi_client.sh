#!/bin/bash

set -x

echo "install_mpi_client.sh"

# We run MPI using the network installation, so we only need to add that to our path(s). Make sure all users
#  have this in their path(s).
echo 'export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin' | sudo tee -a /etc/skel/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/shared/openmpi/3.1.2/lib/' | sudo tee -a /etc/skel/.bashrc

# Guarantee LD_LIBRARY_PATH isn't empty, so we don't have a leading colon in it during a later export (which
#  would lead to a security hole where Linux first searches the current directory for libraries!)
echo 'export LD_LIBRARY_PATH=/opt/shared/openmpi/3.1.2/lib/' | sudo tee -a /etc/environment

# Set path right now.
sudo export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin
sudo export LD_LIBRARY_PATH=/opt/shared/openmpi/3.1.2/lib/
