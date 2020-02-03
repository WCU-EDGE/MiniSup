#!/bin/bash

echo 'install_mpi.sh'

USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')

set -x

# Get the pmi file into the correct location, or MPI is unable to find it.
sudo cp /software/slurm/include/slurm/pmi.h /software/slurm/include/
#sudo ln -s /software/slurm/include/slurm/pmi.h /software/slurm/include/pmi.h

# Install MPI itself
sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.5.tar.gz
gunzip -c openmpi-3.1.5.tar.gz | tar xf -
cd openmpi-3.1.5
sudo ./configure --prefix=/software/openmpi --with-slurm --with-pmi=/usr -q
sudo make all install
PATH=$PATH:/software/openmpi/bin

# We run MPI using the network installation, so we need to add that to our path(s). Make sure all users
#  have this in their path(s).
echo 'export PATH=$PATH:/software/openmpi/bin' | sudo tee -a /etc/skel/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/openmpi/lib/' | sudo tee -a /etc/skel/.bashrc

# Everyone should look to the openmpi binaries.
sudo sed -i '/^PATH/ s/\"$/\:\/software\/openmpi\/bin\"/g' /etc/environment

# Guarantee LD_LIBRARY_PATH isn't empty, so we don't have a leading colon in it during a later export (which
#  would lead to a security hole where Linux first searches the current directory for libraries!)
echo 'export LD_LIBRARY_PATH=/software/openmpi/lib/' | sudo tee -a /etc/environment

# Set path right now.
export PATH=$PATH:/software/openmpi/bin
export LD_LIBRARY_PATH=/software/openmpi/lib/

# Make sure everyone picks up the paths!
for i in $USERNAMELIST 
do
    sudo mkdir /home/$i || true
    sudo chown $i /home/$i
    sudo touch /home/$i/.bashrc
    echo 'export PATH=$PATH:/software/openmpi/bin' | sudo tee -a /home/$i/.bashrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/openmpi/lib/' | sudo tee -a /home/$i/.bashrc
    sudo mkdir /users/$i || true
    sudo chown $i /users/$i
    sudo touch /users/$i/.bashrc
    echo 'export PATH=$PATH:/software/openmpi/bin' | sudo tee -a /users/$i/.bashrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/openmpi/lib/' | sudo tee -a /users/$i/.bashrc
done

# Create the machine list for MPI workers to use
MACHINELISTFILE=/mpishare/machinelist
for m in $(seq 1 $1)
do
  echo "worker-${m}" | sudo tee -a $MACHINELISTFILE
done
sudo chmod 755 $MACHINELISTFILE 

cd ..
sudo rm -Rf openmpi-3.1.5
sudo rm -Rf openmpi-3.1.5.tar.gz
