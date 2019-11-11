#!/bin/bash
set -x

echo 'slurmHead.sh'

sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git gcc make ruby ruby-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev
sudo gem install fpm
cd /opt
sudo git clone https://github.com/mknoxnv/ubuntu-slurm.git

HOSTNAMETRIM=$(echo $HOSTNAME | awk -F'.' '{print $1}')
sudo sed -i "s/ControlMachine=slurm-ctrl/ControlMachine=$HOSTNAMETRIM/g" ubuntu-slurm/slurm.conf
SLURMMACHINELIST=worker[1-$(($1))]
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

cd /opt
sudo wget https://download.schedmd.com/slurm/slurm-17.11.12.tar.bz2
sudo tar xvjf slurm-17.11.12.tar.bz2
cd slurm-17.11.12
sudo ./configure --prefix=/tmp/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
sudo make
sudo make contrib
sudo make install
cd ..
sudo fpm -s dir -t deb -v 1.0 -n slurm-17.11.12 --prefix=/usr -C /tmp/slurm-build .

sudo dpkg -i slurm-17.11.12_1.0_amd64.deb  
sudo useradd slurm
sudo mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
sudo chown slurm /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm

cd /opt
sudo cp ubuntu-slurm/slurmdbd.service /etc/systemd/system/
sudo cp ubuntu-slurm/slurmctld.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld

sudo cp ubuntu-slurm/slurm.conf /etc/slurm-llnl/
sudo sacctmgr add cluster compute-cluster
sudo sacctmgr add account compute-account description="Compute accounts" Organization=OurOrg
sudo sacctmgr create user myuser account=compute-account adminlevel=None
#sudo sinfo  # test query

