#!/bin/bash

set -x

echo 'slurmClient.sh'

sudo apt-get update -y
sudo apt-get install -y libmunge-dev libmunge2 munge

# Wait until the proper files exist.
while [ ! -d /software/mungedata ]; do
    sleep 60
done
while [ ! -f /software/mungedata/munge.key ]; do
    sleep 60
done

sudo cp /software/mungedata/munge.key /etc/munge/
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

sudo systemctl enable munge
sudo systemctl restart munge

sudo dpkg -i /software/slurm-17.11.12_1.0_amd64.deb
sudo mkdir /etc/slurm

while [ ! -f /software/mungedata/slurm.conf ]; do
    sleep 60
done

sudo cp /software/mungedata/slurm.conf /etc/slurm/
sudo cp /local/repository/slurm/gres.conf /etc/slurm/
sudo cp /local/repository/slurm/cgroup.conf /etc/slurm/
sudo cp /local/repository/slurm/cgroup_allowed_devices_file.conf /etc/slurm/
sudo cp /local/repository/slurm/slurmd.service /etc/systemd/system/

sudo chown root:root /etc/slurm/slurm.conf
sudo chown root:root /etc/slurm/gres.conf
sudo chown root:root /etc/slurm/cgroup.conf
sudo chown root:root /etc/slurm/cgroup_allowed_devices_file.conf
sudo chown root:root /etc/slurm/slurmd.service

sudo chmod 644 /etc/slurm/slurm.conf
sudo chmod 644 /etc/slurm/gres.conf
sudo chmod 644 /etc/slurm/cgroup.conf
sudo chmod 644 /etc/slurm/cgroup_allowed_devices_file.conf
sudo chmod 644 /etc/slurm/slurmd.service

#If necessary modify gres.conf to reflect the properties of this compute node.
#gres.conf.dgx is an example configuration for the DGX-1.
#Use "nvidia-smi topo -m" to find the GPU-CPU affinity.
#
#The node-config.sh script will, if run on the compute node, output the appropriate lines to
#add to slurm.conf and gres.conf.

sudo mkdir -p /var/spool/slurm/d

sudo systemctl enable slurmd
sudo systemctl start slurmd
