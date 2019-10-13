#!/bin/bash

sudo apt-get install -y expect

sudo ldapsearch -H ldapi:// -LLL -Q -Y EXTERNAL -b "cn=config" "(olcRootDN=*)" dn olcRootDN olcRootPW | tee updpasswd.ldif

sudo sed -i 's/olcRootPW/changetype: modify\nreplace: olcRootPW\n#olcRootPW/g' updpasswd.ldif
sudo sed -i 's/olcRootDN/#olcRootDN/g' updpasswd.ldif
sudo printf "rams" > inputpwd
sudo /usr/sbin/slappasswd -h {SSHA} -T inputpwd >> updpasswd.ldif
sudo rm inputpwd
sudo sed -i '$ s/{SSHA}/olcRootPW: {SSHA}/g' updpasswd.ldif
sudo ldapmodify -H ldapi:// -Y EXTERNAL -f updpasswd.ldif
sudo sed -i '1 s/^.*$/dn: cn=admin,dc=csc,dc=wcupa,dc=edu/' updpasswd.ldif
sudo sed -i 's/replace: oldRootPW/replace: userPassword/g' updpasswd.ldif
sudo sed -i 's/olcRootPW: {SSHA}/userPassword: {SSHA}/g' updpasswd.ldif

ldapmodify -H ldap:// -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -W -f updpasswd.ldif

echo '#!/usr/bin/expect -f' > ldapexpect.sh
echo 'set timeout -1' >> ldapexpect.sh
echo 'spawn ldapmodify -H ldap:// -x -D "cn=admin,dc=csc,dc=wcupa,dc=edu" -W -f updpasswd.ldif' >> ldapexpect.sh
echo 'expect "Enter LDAP Password: "' >> ldapexpect.sh
echo 'send -- "rams\r"' >> ldapexpect.sh
echo 'expect eof' >> ldapexpect.sh
sudo chmod 777 ldapexpect.sh
sudo ./ldapexpect.sh
sudo rm ldapexpect.sh
