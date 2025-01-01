#!/bin/bash


# slappasswd -h {SSHA} -s jai

set -x 

install -m 0700 -o ldap -g ldap -d /var/lib/openldap/openldap-data/

install -m 0760 -o root -g ldap -d /etc/openldap/slapd.d

# Add configurations
slapadd -n 0 -F /etc/openldap/slapd.d/ -l /etc/openldap/config.ldif
chown -R ldap:ldap /etc/openldap/*

# Enable SSL configuration
cd ~
# openssl req -new -x509 -nodes -out slapdcert.pem -keyout slapdkey.pem -days 365
mkdir /etc/openldap/ssl/
mv slapdcert.pem slapdkey.pem /etc/openldap/ssl/
chmod -R 755 /etc/openldap/ssl/
chmod 400 /etc/openldap/ssl/slapdkey.pem
chmod 444 /etc/openldap/ssl/slapdcert.pem
chown ldap /etc/openldap/ssl/slapdkey.pem


# Start the service in background (Normal Mode)
# nohup /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldap:/// ldapi:///" &
# Start the service in background (SSL Mode)
# nohup /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldap:/// ldaps:/// ldapi:///" -4 -d Config,Stats | tee /var/log/slapd.log &
nohup /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldap:/// ldaps:/// ldapi:///" -4 -d Config,Stats > /var/log/slapd.log 2>&1 &

ps -ef
sleep 2

# Add Manager account for administrative tasks
ldapadd -x -D 'cn=Manager,dc=jai,dc=net' -w jai -f /root/me.ldif

sleep 1

ldapmodify -D 'cn=Manager,dc=jai,dc=net' -w jai -f /root/sslOptions.ldif



# PART 2.1 - LDAP Setup
cd ~
slapmodify -n 0 -l allowpwchange.ldif
# ldapadd -D "cn=Manager,dc=jai,dc=net" -w jai -f base.ldif
ldapsearch -x -b 'dc=jai,dc=net' '(objectclass=*)'
ldapadd -D "cn=Manager,dc=jai,dc=net" -w jai -f manager.ldif
ldapadd -D "cn=Manager,dc=jai,dc=net" -w jai -f people_group.ldif

ldapadd -D "cn=Manager,dc=jai,dc=net" -w jai -f user_joe.ldif
ldapadd -D "cn=Manager,dc=jai,dc=net" -w jai -f group_joe.ldif

# PART 2.2 - Client Setup - Online

chmod 0600 /etc/nslcd.conf
# nohup /usr/bin/nslcd --nofork &
nohup /usr/bin/nslcd --debug > /var/log/nslcd.log 2>&1 &
ps -ef

# PART 2.2 - Client Setup - Online - Offline

# chmod 600 /etc/sssd/sssd.conf

# /bin/chown -f -R root:sssd /etc/sssd
# /bin/chmod -f -R g+r /etc/sssd
# /bin/sh -c "/bin/chown -f sssd:sssd /var/lib/sss/db/*.ldb"
# /bin/chown -f -R sssd:sssd /var/lib/sss/gpo_cache
# /bin/sh -c "/bin/chown -f sssd:sssd /var/log/sssd/*.log"
# DEBUG_LOGGER=--logger=files /usr/bin/sssd -i ${DEBUG_LOGGER}