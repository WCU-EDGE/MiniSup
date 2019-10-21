#!/bin/bash
set -x

ldap_password='admin'
ldap_dn='dc=csc,dc=wcupa,dc=edu'
ldap_ip_addr=192.168.1.1
ldap_hashed_pw=`slappasswd -s $ldap_password`

cat << EOF > /etc/ldap/ldap.conf
BASE    $ldap_dn
URI     ldap://$ldap_ip_addr
SSL     no
pam_password    md5
TLS_CACERT      /etc/ssl/certs/ca-certificates.crt
EOF

#dpkg-reconfigure -f noninteractive slapd
dpkg-reconfigure slapd

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/core.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif 

cat << EOF > database.ldif
dn: olcDatabase={1}hdb,cn=config
changetype: modify
replace: olcRootPW

olcRootPW: $ldap_hashed_pw
dn: olcDatabase={1}hdb,cn=config
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange by dn="cn=admin,$dn" write by anonymous auth by self write by * none
olcAccess: {1}to dn.subtree="" by * read
olcAccess: {2}to * by dn="cn=admin,$dn" write by * read

dn: olcDatabase={1}hdb,cn=config
add: olcDbIndex
olcDbIndex: uid,gidNumber,uidNumber pres,eq
olcDbIndex: cn,sn,mail,givenName,memberUid pres,eq,approx,sub

dn: olcDatabase={-1}frontend,cn=config
changetype: modify
delete: olcAccess

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootDN
olcRootDN: cn=admin,cn=config

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $ldap_hashed_pw
EOF

ldapmodify -Y EXTERNAL -H ldapi:/// -f database.ldif

#echo '/home 192.168.1.0/24(rw)' >> /etc/exports
#mkdir -p /etc/exports.d
#/etc/init.d/nfs-kernel-server restart
