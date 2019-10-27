#!/bin/bash
set -x

### #!/bin/sh

echo 'nodeHead.sh'

mkdir /software
#mkdir /scratch
sudo chown nobody:nogroup /software
#sudo chown nobody:nogroup /scratch
sudo chown nobody:nogroup /home

sudo chmod -R a+rx /software
#sudo chmod -R 777 /scratch
sudo chmod -R 777 /home
sudo chmod -R a+rx /opt

sudo apt-get update
sudo apt-get install -y debconf-utils

# debconf
echo 'debconf start'
export DEBIAN_FRONTEND=noninteractive
#sudo sh -c 'cat /local/repository/preseedHead.deb | debconf-set-selections'
cat /local/repository/preseedHead.deb | sudo debconf-set-selections
echo 'debconf end'

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

#sudo /local/repository/ldif/configLdap.sh

sudo dpkg-reconfigure slapd
sudo ufw allow ldap

### Correctly set the LDAP password.
echo 'running nodeHeadLdapPwd.sh'
sudo /local/repository/nodeHeadLdapPwd.sh
echo 'done nodeHeadLdapPwd.sh'

sudo /local/repository/ldif/createUsersLdif.sh
sudo ldapadd -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -w admin -f /local/repository/ldif/basedln.ldif
sudo ldapadd -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -w admin -f /local/repository/ldif/users.ldif

#sudo ldapadd -x -D cn=admin,dc=csc,dc=wcupa,dc=edu -w admin -f /local/repository/ldif/basedln.ldif
#sudo ldapadd -x -D cn=admin,dc=csc,dc=wcupa,dc=edu -w admin -f /local/repository/ldif/users.ldif

#sudo ldapadd -x -D cn=admin,dc=csc,dc=wcupa,dc=edu -W -f /local/repository/ldif/basedln.ldif
#sudo ldapadd -x -D cn=admin,dc=csc,dc=wcupa,dc=edu -W -f /local/repository/users.ldif

sudo apt-get install -y nfs-kernel-server
#apt-get install -y nfs-utils nfs-utils-lib
#yum install -y nfs-utils nfs-utils-lib

# Create the permissions file for the NFS directory.
computes=$(($1 + 1))
for i in $(seq 2 $computes)
do
  echo "/home 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/opt 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  echo "/software 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  #echo "/scratch 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
done

sudo systemctl restart nfs-kernel-server

#chkconfig nfs on
#service rpcbind start
#service nfs start


## Copy, if exists.
#cp /local/repository/source/* /scratch || true

## Next step: MPI ####################
#cd /software
#sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
#sudo tar xzf openmpi-3.1.2.tar.gz
#cd openmpi-3.1.2
#sudo ./configure --prefix=/software
#sudo make
#sudo make all install
#echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
#echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
#cd ..
#sudo rm -Rf openmpi-3.1.2
#sudo rm -Rf openmpi-3.1.2.tar.gz
#echo "Done" >> /users/jk880380/headdoneMPI.txt


## Create the permissions file for the NFS directory.
#computes=$(($1 + 1))
#for i in $(seq $computes)
#do
#  st='/software 192.168.1.'
#  st+=$(($i))
#  st+='(rw,sync,no_root_squash,no_subtree_check)'
#  echo $st >> /etc/exports
#done

#exportfs -a
#echo "Done" >> /users/jk880380/headdoneNFS.txt



# Storage.

#touch /etc/exports
#touch /scratch/machine_list
#echo 'storage' >> /scratch/machine_list
#computes=$(($1 + 0))
#for i in $(seq $computes)
#do
#  st='/scratch 192.168.1.'
#  st+=$(($i + 2))
#  st+='(rw,sync,no_root_squash,no_subtree_check)'
#  echo $st >> /etc/exports
#  
#  st2='compute-'
#  st2+=$(($i + 0))
#  #st2='192.168.1.'
#  #st2+=$(($i + 2))
#  echo $st2 >> /scratch/machine_list
#done
#
#exportfs -a

#sleep 600
#mkdir /software
#mount -t nfs 192.168.1.1:/software /software
mkdir /software/flagdir
echo "Done" >> /users/jk880380/DONEnfsheadandstorage.txt
