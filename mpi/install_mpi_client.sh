#!/bin/bash

set -x

echo "install_mpi_client.sh"

#echo "export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin" >> /users/$USER/.bashrc
#echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/shared/openmpi/3.1.2/lib/" >> /users/$USER/.bashrc
#source ~/.bashrc

# We run MPI using the network installation, so we only need to add that to our path(s)
echo "export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin" >> /etc/skel/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/shared/openmpi/3.1.2/lib/" >> /etc/skel/.bashrc
source ~/.bashrc
