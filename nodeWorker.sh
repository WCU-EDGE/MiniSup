#!/bin/bash
set -x

### #!/bin/sh

echo 'nodeWorker.sh'

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo /local/repository/ldap/installLdapClient.sh
sudo /local/repository/nfs/installNfsClient.sh

echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
source ~/.bashrc

sudo /local/repository/mpi/install_mpi_client.sh

#while [ ! -d /scratch/flagdir ]
#do
#  sleep 30
#done

echo "Done" >> /users/jk880380/clientdone.txt
