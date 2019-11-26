#!/bin/bash
set -x

echo 'slurmHead.sh'

#sudo useradd slurm
#sudo mkdir /var/tmp/slurmpid
#sudo chmod 777 /var/tmp/slurmpid
#sudo chown slurm: /var/tmp/slurmpid

sudo apt-get update -y
#sudo apt-get install -y nfs-common
#sudo mkdir /software
#sudo mount 192.168.1.1:/software /software || true
## Cycle until we can mount home.
#while [ mount | grep software > /dev/null ]; do
#  sudo mount 192.168.1.1:/software /software || true
#  sleep 60
#done

#sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git gcc make ruby ruby-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev
sudo gem install fpm
#cd /opt
cd /software
sudo git clone https://github.com/mknoxnv/ubuntu-slurm.git

HOSTNAMETRIM=$(echo $HOSTNAME | awk -F'.' '{print $1}')
sudo sed -i "s/ControlMachine=slurm-ctrl/ControlMachine=$HOSTNAMETRIM/g" ubuntu-slurm/slurm.conf
SLURMMACHINELIST=worker-[1-$(($1))]
sudo sed -i "s/NodeName=linux1/NodeName=$SLURMMACHINELIST/g" ubuntu-slurm/slurm.conf

sudo apt-get install -y libmunge-dev libmunge2 munge
sudo systemctl enable munge
sudo systemctl start munge

sudo apt-get install -y mariadb-server
sudo systemctl enable mysql
sudo systemctl start mysql
#sudo mysql -u root  # testing to make sure mariadb is live

cat << EOF > /tmp/setupmaria.sql
create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('goldenram');
grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;
exit
EOF

sudo mysql -u root < /tmp/setupmaria.sql

#cd /opt
cd /software
sudo wget https://download.schedmd.com/slurm/slurm-17.11.12.tar.bz2
sudo tar xvjf slurm-17.11.12.tar.bz2
cd slurm-17.11.12
#sudo ./configure --prefix=/tmp/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
#sudo ./configure --prefix=/software/slurm --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
sudo ./configure --prefix=/software/slurm --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm --with-pmix
sudo make
sudo make contrib
sudo make install
cd ..
sudo fpm -s dir -t deb -v 1.0 -n slurm-17.11.12 --prefix=/usr -C /software/slurm .

sudo dpkg -i slurm-17.11.12_1.0_amd64.deb  
sudo useradd slurm
sudo mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
sudo chown slurm /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm

sudo cp /local/repository/slurm/slurmdbd.conf /etc/slurm/slurmdbd.conf
sudo chown slurm: /etc/slurm/slurmdbd.conf
sudo chmod 755 /etc/slurm/slurmdbd.conf
sudo touch /var/log/slurm/slurmdbd.log
sudo chown slurm: /var/log/slurm/slurmdbd.log
sudo chmod 755 /var/log/slurm/slurmdbd.log

#cd /opt
cd /software
sudo cp /local/repository/slurm/slurmdbd.service /etc/systemd/system/
sudo cp /local/repository/slurm/slurmctld.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/slurmdbd.service
sudo chown root:root /etc/systemd/system/slurmctld.service
sudo chmod 644 /etc/systemd/system/slurmdbd.service
sudo chmod 644 /etc/systemd/system/slurmctld.service
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld


##sudo cp ubuntu-slurm/slurm.conf /etc/slurm-llnl/
#sudo cp ubuntu-slurm/slurm.conf /etc/slurm/

# For the head node to use
sudo cp /local/repository/slurm/slurm.conf /etc/slurm/
sudo chown root:root /etc/slurm/slurm.conf
sudo chmod 644 /etc/slurm/slurm.conf

sudo sacctmgr --immediate add cluster compute-cluster
sudo sacctmgr --immediate add account compute-account description="Compute accounts" Organization=WCUPA
sudo sacctmgr --immediate create user myuser account=compute-account adminlevel=None
#sudo sinfo  # test query

# Copy the key for the clients to use
sudo mkdir /software/mungedata
sudo cp /etc/munge/munge.key /software/mungedata/
sudo cp /local/repository/slurm/slurm.conf /software/mungedata/
