#!/bin/bash


# slappasswd -h {SSHA} -s jai

set -x 


# PART 2.2 - Client Setup - Online

# chmod 0600 /etc/nslcd.conf
# nohup /usr/bin/nslcd --nofork &
# nohup /usr/bin/nslcd --debug > /var/log/nslcd.log 2>&1 &
# ps -ef

# PART 2.2 - Client Setup - Online - Offline

chmod 600 /etc/sssd/sssd.conf

chmod 0600 /etc/nslcd.conf
# nohup /usr/bin/nslcd --nofork &
nohup /usr/bin/nslcd --debug > /var/log/nslcd.log 2>&1 &
ps -ef

sleep 1

/bin/chown -f -R root:sssd /etc/sssd
/bin/chmod -f -R g+r /etc/sssd
/bin/sh -c "/bin/chown -f sssd:sssd /var/lib/sss/db/*.ldb"
/bin/chown -f -R sssd:sssd /var/lib/sss/gpo_cache
/bin/sh -c "/bin/chown -f sssd:sssd /var/log/sssd/*.log"
# /usr/bin/sssd -i --logger=files
/usr/bin/sssd -D -d 5 --logger=files


# /bin/chown -f -R root:sssd /etc/sssd
# /bin/chmod -f -R g+r /etc/sssd
# /bin/sh -c "/bin/chown -f sssd:sssd /var/lib/sss/db/*.ldb"
# /bin/chown -f -R sssd:sssd /var/lib/sss/gpo_cache
# /bin/sh -c "/bin/chown -f sssd:sssd /var/log/sssd/*.log"
# DEBUG_LOGGER=--logger=files /usr/bin/sssd -i ${DEBUG_LOGGER}