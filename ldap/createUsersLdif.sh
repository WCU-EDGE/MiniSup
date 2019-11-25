#!/bin/bash

echo 'createUsersLdif'

PWD_1=$(slappasswd -s rams)
PWD_2=$(slappasswd -s goldenram)

cat <<EOF > /local/repository/ldap/users.ldif
dn: uid=merino,ou=People,dc=csc,dc=wcupa,dc=edu
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: merino
sn: Merino
givenName: Golden
cn: merino
displayName: merino
uidNumber: 10000
gidNumber: 5000
userPassword: $PWD_1
gecos: Golden Merino
loginShell: /bin/bash
homeDirectory: /home/merino

dn: uid=dorper,ou=People,dc=csc,dc=wcupa,dc=edu
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: dorper
sn: Dorper
givenName: Golden
cn: dorper
displayName: dorper
uidNumber: 10001
gidNumber: 5000
userPassword: $PWD_1
gecos: Golden Dorper
loginShell: /bin/bash
homeDirectory: /home/dorper

dn: uid=tester,ou=People,dc=csc,dc=wcupa,dc=edu
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: tester
sn: Tester
givenName: Golden
cn: tester
displayName: tester
uidNumber: 10002
gidNumber: 5000
userPassword: $PWD_1
gecos: Golden Tester
loginShell: /bin/bash
homeDirectory: /home/tester

dn: uid=slurm,ou=People,dc=csc,dc=wcupa,dc=edu
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: slurm
sn: Slurm
givenName: SlurmUser
cn: slurm
displayName: slurm
uidNumber: 10003
gidNumber: 5000
userPassword: $PWD_2
gecos: Slurm User
loginShell: /bin/bash
homeDirectory: /home/slurm
EOF
