> Create network if not already present.
```bash
docker network create krb5
```

## KDC setup
Build the image.
```bash
cd /mnt/c/DevBox/kerberos/archlinux/ldap
docker buildx build -t kldap:v1 .
```

Run the container.
```bash
docker run -dit --net=krb5 --name kldap --hostname kldap.jai.net kldap:v1 /bin/bash
```

Once container is started run below command to setup and start the Kerberos service.
```bash
docker exec kldap krb5kdc && docker exec kldap kadmind && docker exec kldap ps -ef
```


# docker buildx build -t kldap:v1 .
# docker stop kldap 
# docker rm kldap
# docker attach kldap
# docker run -dit --net=krb5 --name kldap --hostname kldap.jai.net -p 389:389/tcp -p 389:389/udp -p 666:666/tcp -p 666:666/udp -p 636:636/tcp -p 636:636/udp kldap:v1 /bin/bash
# docker run -dit --net=krb5 --name kldap --hostname kldap.jai.net -p 389:389/tcp -p 666:666/tcp -p 636:636/tcp kldap:v1 /bin/bash
# docker exec kldap /setup-service.sh

## docker rm -f kldap && docker run -dit --net=krb5 --name kldap --hostname kldap.jai.net -p 389:389/tcp -p 666:666/tcp -p 636:636/tcp kldap:v1 /bin/bash && docker exec kldap /setup-service.sh && docker attach kldap

nohup /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldap:/// ldaps:/// ldapi:///" -4 -d Config,Stats | tee /var/log/slapd.log &
nohup /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldap:/// ldaps:/// ldapi:///" -4 -d Config,Stats >> /var/log/slapd.log &

docker exec kldap ldapsearch -x '(objectclass=*)' -b 'dc=jai,dc=net'

docker exec kldap ldapsearch -D "cn=Manager,dc=jai,dc=net" -W '(objectclass=*)' -b 'dc=jai,dc=net'

docker exec kldap ldapsearch -D "cn=Manager,dc=jai,dc=net" -w jai '(objectclass=*)' -b 'dc=jai,dc=net'

ldapsearch -x -H ldap://kldap.jai.net:389 -D "cn=Manager,dc=jai,dc=net"
ldapsearch -x -H ldap://kldap.jai.net:389 -D "cn=Manager,dc=jai,dc=net" -W
ldapsearch -x -H ldap://kldap.jai.net:389 -D "cn=Manager,dc=jai,dc=net" -w jai
ldapsearch -x -H ldaps://kldap.jai.net:636 -D "cn=Manager,dc=jai,dc=net"
ldapsearch -x -H ldaps://kldap.jai.net:636 -D "cn=Manager,dc=jai,dc=net" -W
ldapsearch -x -H ldaps://kldap.jai.net:636 -D "cn=Manager,dc=jai,dc=net" -w jai


ldapsearch -x -H ldaps://kldap.jai.net:636 -D "cn=Manager,dc=jai,dc=net" -w jai -b "ou=People,dc=jai,dc=net" "(objectclass=*)"







/usr/bin/nslcd --nofork
nohup /usr/bin/nslcd --nofork &



nohup /usr/lib/slapd -d 0 -u ldap -g ldap -h "ldaps:///" &




References:  
[LDAP authentication](https://wiki.archlinux.org/title/LDAP_authentication)  
[OpenLDAP](https://wiki.archlinux.org/title/OpenLDAP)  
[nss-pam-ldapd](https://arthurdejong.org/nss-pam-ldapd/docs)









[root@kldap /]# cat /usr/lib/systemd/system/sssd.service
[Unit]
Description=System Security Services Daemon
# SSSD must be running before we permit user sessions
Before=systemd-user-sessions.service nss-user-lookup.target
Wants=nss-user-lookup.target
StartLimitIntervalSec=50s
StartLimitBurst=5
ConditionPathExists=|/etc/sssd/sssd.conf
ConditionDirectoryNotEmpty=|/etc/sssd/conf.d/

[Service]
Environment=DEBUG_LOGGER=--logger=files
EnvironmentFile=-/etc/sysconfig/sssd
ExecStartPre=+-/bin/chown -f -R root:sssd /etc/sssd
ExecStartPre=+-/bin/chmod -f -R g+r /etc/sssd
ExecStartPre=+-/bin/sh -c "/bin/chown -f sssd:sssd /var/lib/sss/db/*.ldb"
ExecStartPre=+-/bin/chown -f -R sssd:sssd /var/lib/sss/gpo_cache
ExecStartPre=+-/bin/sh -c "/bin/chown -f sssd:sssd /var/log/sssd/*.log"
ExecStart=/usr/bin/sssd -i ${DEBUG_LOGGER}
Type=notify
NotifyAccess=main
Restart=on-abnormal
CapabilityBoundingSet= CAP_SETGID CAP_SETUID CAP_DAC_READ_SEARCH
SecureBits=noroot noroot-locked
User=sssd
Group=sssd
# If service configured to be run under "root", uncomment "SupplementaryGroups"
#SupplementaryGroups=sssd





/bin/chown -f -R root:sssd /etc/sssd
/bin/chmod -f -R g+r /etc/sssd
/bin/sh -c "/bin/chown -f sssd:sssd /var/lib/sss/db/*.ldb"
/bin/chown -f -R sssd:sssd /var/lib/sss/gpo_cache
/bin/sh -c "/bin/chown -f sssd:sssd /var/log/sssd/*.log"
DEBUG_LOGGER=--logger=files /usr/bin/sssd -i ${DEBUG_LOGGER}