#!/bin/bash
debconf-cleaner(){
apt-get purge -y libnss-ldap libpam-ldap ldap-utils nscd
echo PURGE | debconf-communicate libnss-ldap
echo PURGE | debconf-communicate libpam-ldap
echo PURGE | debconf-communicate nscd
echo PURGE | debconf-communicate ldap-utils
}

cat << EOF > list1
libnss-ldap	libnss-ldap/confperm	boolean	false
libnss-ldap	libnss-ldap/nsswitch	note
libnss-ldap	shared/ldapns/base-dn	string	dc=example,dc=net
libnss-ldap	libnss-ldap/dblogin	boolean	true
libnss-ldap	libnss-ldap/override	boolean	true
libnss-ldap	libnss-ldap/binddn	string	cn=admin,dc=example,dc=net
libnss-ldap	libnss-ldap/bindpw	string	password-here
libnss-ldap	shared/ldapns/ldap_version	select	3
libnss-ldap	shared/ldapns/ldap-server	string	ldaps://ldap.example.net
libnss-ldap	libnss-ldap/dbrootlogin	boolean	true
libnss-ldap	libnss-ldap/rootbinddn	string	cn=admin,dc=example,dc=net
libnss-ldap	libnss-ldap/rootbindpw	string	password-here
EOF

cat << EOF > list2
libpam-ldap	libpam-ldap/confperm	boolean	false
libpam-ldap	libpam-ldap/nsswitch	note
libpam-ldap	shared/ldapns/base-dn	string	dc=example,dc=net
libpam-ldap	libpam-ldap/dblogin	boolean	false
libpam-ldap	libpam-ldap/override	boolean	true
libpam-ldap	libpam-ldap/binddn	string	cn=admin,dc=example,dc=net
libpam-ldap	libpam-ldap/bindpw	string	password-here
libpam-ldap	shared/ldapns/ldap_version	select	3
libpam-ldap	shared/ldapns/ldap-server	string	ldaps://ldap.example.net
libpam-ldap	libpam-ldap/dbrootlogin	boolean	true
libpam-ldap	libpam-ldap/rootbinddn	string	cn=admin,dc=example,dc=net
libpam-ldap	libpam-ldap/rootbindpw	string	password-here

EOF

configurator(){
debconf-set-selections list1
debconf-set-selections list2
sleep 2
clear
debconf-show libnss-ldap
sleep 2
clear
debconf-show libpam-ldap
sleep 2
clear
debconf-show nscd
sleep 2
clear
apt-get install -y libnss-ldap libpam-ldap ldap-utils nscd
/etc/init.d/nscd restart
}

debconf-cleaner
configurator
exit
