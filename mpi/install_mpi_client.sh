#!/bin/bash

set -x

echo "install_mpi_client.sh"

echo "export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin" >> /users/$USER/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/shared/openmpi/3.1.2/lib/" >> /users/$USER/.bashrc
