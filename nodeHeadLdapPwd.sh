#!/bin/bash

echo 'nodeHeadLdapPwd.sh'

sudo apt-get install -y expect

#sudo ldapsearch -H ldapi:// -LLL -Q -Y EXTERNAL -b "cn=config" "(olcRootDN=*)" dn olcRootDN olcRootPW | tee updpasswd.ldif
sudo ldapsearch -H ldap:// -LLL -Q -Y EXTERNAL -b "cn=config" "(olcRootDN=*)" dn olcRootDN olcRootPW | tee /tmp/updpasswd.ldif

sudo sed -i 's/olcRootPW/changetype: modify\nreplace: olcRootPW\n#olcRootPW/g' /tmp/updpasswd.ldif
sudo sed -i 's/olcRootDN/#olcRootDN/g' /tmp/updpasswd.ldif
sudo printf "rams" > /tmp/inputpwd
sudo /usr/sbin/slappasswd -h {SSHA} -T /tmp/inputpwd >> /tmp/updpasswd.ldif
#sudo rm /tmp/inputpwd
sudo sed -i '$ s/{SSHA}/olcRootPW: {SSHA}/g' /tmp/updpasswd.ldif
#sudo ldapmodify -H ldapi:// -Y EXTERNAL -f updpasswd.ldif
sudo ldapmodify -H ldap://192.168.1.1 -Y EXTERNAL -f /tmp/updpasswd.ldif
sudo sed -i '1 s/^.*$/dn: cn=admin,dc=csc,dc=wcupa,dc=edu/' /tmp/updpasswd.ldif
sudo sed -i 's/replace: oldRootPW/replace: userPassword/g' /tmp/updpasswd.ldif
sudo sed -i 's/olcRootPW: {SSHA}/userPassword: {SSHA}/g' /tmp/updpasswd.ldif

ldapmodify -H ldap://192.168.1.1 -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -W -f /tmp/updpasswd.ldif

echo '#!/usr/bin/expect -f' > /tmp/ldapexpect.sh
echo 'set timeout -1' >> /tmp/ldapexpect.sh
echo 'spawn ldapmodify -H ldap:// -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -W -f /tmp/updpasswd.ldif' >> /tmp/ldapexpect.sh
echo 'expect "Enter LDAP Password: "' >> /tmp/ldapexpect.sh
echo 'send -- "rams\r"' >> /tmp/ldapexpect.sh
echo 'expect eof' >> /tmp/ldapexpect.sh
sudo chmod 777 /tmp/ldapexpect.sh
sudo /tmp/ldapexpect.sh
#sudo rm /tmp/ldapexpect.sh
