#!/bin/bash

set -x

echo 'slurmClient.sh'

sudo apt-get update -y
sudo apt-get install -y libmunge-dev libmunge2 munge

# Below 

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

## scp will request to save the ssh connection!

sudo systemctl enable munge
sudo systemctl restart munge

sudo dpkg -i /software/slurm-17.11.12_1.0_amd64.deb
sudo mkdir /etc/slurm

sudo cp /storage/ubuntu-slurm/slurm.conf /etc/slurm/slurm.conf

#If necessary modify gres.conf to reflect the properties of this compute node.
#gres.conf.dgx is an example configuration for the DGX-1.
#Use "nvidia-smi topo -m" to find the GPU-CPU affinity.
#
#The node-config.sh script will, if run on the compute node, output the appropriate lines to
#add to slurm.conf and gres.conf.

sudo cp /storage/ubuntu-slurm/gres.conf /etc/slurm/gres.conf
sudo cp /storage/ubuntu-slurm/cgroup.conf /etc/slurm/cgroup.conf
sudo cp /storage/ubuntu-slurm/cgroup_allowed_devices_file.conf /etc/slurm/cgroup_allowed_devices_file.conf
sudo useradd slurm
sudo mkdir -p /var/spool/slurm/d

cp /software/ubuntu-slurm/slurmd.service /etc/systemd/system/
systemctl enable slurmd
systemctl start slurmd
