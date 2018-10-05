>>>>>>>>>>>>>>>>>> OUTDATED. Now this code is in the main head sh <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#!/bin/bash
set -x
sudo yum -y group install "Development Tools"
cd /users/jk880380/software
sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
sudo tar xzf openmpi-3.1.2.tar.gz
cd openmpi-3.1.2
#sudo ./configure --prefix=/opt/openmpi/3.1.2
sudo ./configure --prefix=/users/jk880380/software
sudo make
sudo make all install
echo "export PATH='$PATH:/opt/openmpi/3.1.2/bin'" >> /users/jk880380/.bashrc
#echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/opt/openmpi/3.1.2/lib/'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/users/jk880380/software/lib/'" >> /users/jk880380/.bashrc
cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz
mkdir /users/jk880380/software/flagdir
echo "Done" >> /users/jk880380/headdoneMPI.txt
