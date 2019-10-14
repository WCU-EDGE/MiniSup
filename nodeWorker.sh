#!/bin/bash

### #!/bin/sh

# debconfs
export DEBIAN_FRONTEND=noninteractive

#sudo sh -c 'echo "ldap-auth-config        ldap-auth-config/bindpw rams" | debconf-set-selections'
#sudo sh -c 'echo "ldap-auth-config        ldap-auth-config/rootbindpw rams" | debconf-set-selections'

sudo sh -c 'echo "ldap-auth-config        ldap-auth-config/bindpw password  rams" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config        ldap-auth-config/rootbindpw password  rams" | debconf-set-selections'
sudo sh -c 'echo "libpam-runtime  libpam-runtime/profiles multiselect     unix, ldap, systemd, capability" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/ldapns/ldap-server	string	ldap:///192.168.1.1" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/ldapns/base-dn	string	dc=csc,dc=wcupa,dc=edu" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/move-to-debconf	boolean	true" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/rootbinddn	string	cn=admin,dc=csc,dc=wcupa,dc=edu" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/dblogin	boolean	false" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/pam_password	select md5" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/dbrootlogin	boolean	true" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/ldapns/ldap_version	select	3" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/binddn	string	cn=proxyuser,dc=example,dc=net" | debconf-set-selections'
sudo sh -c 'echo "ldap-auth-config	ldap-auth-config/override	boolean	true" | debconf-set-selections'


#sudo echo "" | sudo debconf-set-selections
#sudo echo "libpam0g:amd64	libpam0g/restart-failed	error	" | sudo debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/conflicts	error	" | sudo debconf-set-selections
#sudo echo "libpam0g	libpam0g/xdm-needs-restart	error	" | sudo debconf-set-selections
#sudo echo "libpam0g:amd64	libpam0g/xdm-needs-restart	error	" | sudo debconf-set-selections
#sudo echo "libpam0g	libraries/restart-without-asking	boolean	false" | sudo debconf-set-selections
#sudo echo "libpam0g:amd64	libraries/restart-without-asking	boolean	false" | sudo debconf-set-selections
#sudo echo "libpam0g	libpam0g/restart-services	string	" | sudo debconf-set-selections
#sudo echo "libpam0g:amd64	libpam0g/restart-services	string	" | sudo debconf-set-selections
#sudo echo "libpam-modules	libpam-modules/disable-screensaver	error	" | sudo debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/profiles	multiselect	unix, ldap, systemd, capability" | sudo debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/no_profiles_chosen	error" | sudo debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/override	boolean	false" | sudo debconf-set-selections

sudo apt-get update
sudo apt-get install -y libnss-ldap libpam-ldap ldap-utils

sudo sed -i 's/compat systemd/compat systemd ldap/g' /etc/nsswitch.conf
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
echo 'session optional pam_mkhomedir.so skel=/etc/skel umask=077' | sudo tee -a /etc/pam.d/common-session

sudo apt-get install -y nfs-common

#chkconfig nfs on
#service rpcbind start
#service nfs start

#mkdir /software
#mkdir /scratch
sleep 600
sudo mount 192.168.1.1:/home /home
sudo mount 192.168.1.1:/opt /opt
sudo mount 192.168.1.1:/software /software
#sudo mount 192.168.1.1:/scratch /scratch
##mount -t nfs 192.168.1.1:/software /software
##mount -t nfs 192.168.1.2:/scratch /scratch

#while [ ! -d /software/flagdir ]
#do
#  sleep 30
#done

echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
source ~/.bashrc

#while [ ! -d /scratch/flagdir ]
#do
#  sleep 30
#done

echo "Done" >> /users/jk880380/clientdone.txt
