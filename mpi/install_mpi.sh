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

# change to your username instead lngo (my username)
echo "export PATH=$PATH:/opt/openmpi/3.1.2/bin" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/openmpi/3.1.2/lib/" >> /users/jk880380/.bashrc
cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz 
