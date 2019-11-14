#!/bin/bash
set -x

echo 'install_mpi.sh'

#sudo yum -y group install "Development Tools"
sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
sudo tar xzf openmpi-3.1.2.tar.gz
cd openmpi-3.1.2
sudo ./configure --prefix=/opt/openmpi/3.1.2 --enable-mpirun-prefix-by-default
sudo make
sudo make all install

# We run MPI using the network installation, so we only need to add that to our path(s). Make sure all users
#  have this in their path(s).
echo 'export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin' | sudo tee -a /etc/skel/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/shared/openmpi/3.1.2/lib/' | sudo tee -a /etc/skel/.bashrc

# Guarantee LD_LIBRARY_PATH isn't empty, so we don't have a leading colon in it during a later export (which
#  would lead to a security hole where Linux first searches the current directory for libraries!)
echo 'export LD_LIBRARY_PATH=/opt/shared/openmpi/3.1.2/lib/' | sudo tee -a /etc/environment

# Everyone should look to the openmpi library.
sudo sed -i '/^PATH/ s/\"$/\:\/opt\/shared\/openmpi\/3.1.2\/bin\"/g' /etc/environment

# Set path right now.
sudo export PATH=$PATH:/opt/shared/openmpi/3.1.2/bin
sudo export LD_LIBRARY_PATH=/opt/shared/openmpi/3.1.2/lib/

cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz 
