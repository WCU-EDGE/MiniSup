#!/bin/bash
set -x

echo 'install_mpi.sh'

wget http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz
tar -xzf mpich-3.3.2.tar.gz
cd mpich-3.3.2
./configure --disable-fortran --prefix=/software/mpi --exec-prefix=/software/mpiexec

### Will want to use this command instead of the one right above, to use Slurm
#./configure --disable-fortran --prefix=/software/mpi --exec-prefix=/software/mpiexec --with-slurm=PATH [and four others - use ./configure --help to see them!]

sudo make
sudo make install
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
USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')
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

# Create the machine list for MPI workers to use
MACHINELISTFILE=/mpishare/machinelist
echo "head" | sudo tee -a $MACHINELISTFILE
for m in $(seq 1 $1)
do
  echo "worker-${m}" | sudo tee -a $MACHINELISTFILE
done
sudo chmod 755 $MACHINELISTFILE 

cd ..
sudo rm -Rf mpich-3.3.2
sudo rm -Rf mpich-3.3.2.tar.gz

########

##sudo yum -y group install "Development Tools"
#sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
#sudo tar xzf openmpi-3.1.2.tar.gz
#cd openmpi-3.1.2
##sudo ./configure --prefix=/opt/openmpi/3.1.2 --enable-mpirun-prefix-by-default
#sudo ./configure --prefix=/software/openmpi/3.1.2 --enable-mpirun-prefix-by-default
#sudo make
#sudo make all install
#
## We run MPI using the network installation, so we only need to add that to our path(s). Make sure all users
##  have this in their path(s).
#echo 'export PATH=$PATH:/software/openmpi/3.1.2/bin' | sudo tee -a /etc/skel/.bashrc
#echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/' | sudo tee -a /etc/skel/.bashrc
#
## Everyone should look to the openmpi binaries.
#sudo sed -i '/^PATH/ s/\"$/\:\/software\/openmpi\/3.1.2\/bin\"/g' /etc/environment
#
## Guarantee LD_LIBRARY_PATH isn't empty, so we don't have a leading colon in it during a later export (which
##  would lead to a security hole where Linux first searches the current directory for libraries!)
#echo 'export LD_LIBRARY_PATH=/software/openmpi/3.1.2/lib/' | sudo tee -a /etc/environment
#
## Set path right now.
#export PATH=$PATH:/software/openmpi/3.1.2/bin
#export LD_LIBRARY_PATH=/software/openmpi/3.1.2/lib/
#
#cd ..
#sudo rm -Rf openmpi-3.1.2
#sudo rm -Rf openmpi-3.1.2.tar.gz 
