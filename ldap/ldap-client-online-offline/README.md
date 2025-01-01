

# docker buildx build -t ldapclient_on_off:v1 .
# docker stop ldapclient_on_off 
# docker rm ldapclient_on_off
# docker attach ldapclient_on_off
# docker run -dit --net=krb5 --name ldapclient_on_off --hostname ldapclient_on_off.jai.net -p 389:389/tcp -p 389:389/udp -p 666:666/tcp -p 666:666/udp -p 636:636/tcp -p 636:636/udp ldapclient_on_off:v1 /bin/bash
# docker run -dit --net=krb5 --name ldapclient_on_off --hostname ldapclient_on_off.jai.net -p 389:389/tcp -p 666:666/tcp -p 636:636/tcp ldapclient_on_off:v1 /bin/bash
# docker exec ldapclient_on_off /setup-service.sh

## docker rm -f ldapclient_on_off && docker run -dit --net=krb5 --name ldapclient_on_off --hostname ldapclient_on_off.jai.net ldapclient_on_off:v1 /bin/bash && docker attach ldapclient_on_off





chmod 600 /etc/sssd/sssd.conf

chmod 0600 /etc/nslcd.conf
# nohup /usr/bin/nslcd --nofork &
nohup /usr/bin/nslcd --debug > /var/log/nslcd.log 2>&1 &
ps -ef



/bin/chown -f -R root:sssd /etc/sssd
/bin/chmod -f -R g+r /etc/sssd
/bin/sh -c "/bin/chown -f sssd:sssd /var/lib/sss/db/*.ldb"
/bin/chown -f -R sssd:sssd /var/lib/sss/gpo_cache
/bin/sh -c "/bin/chown -f sssd:sssd /var/log/sssd/*.log"
/usr/bin/sssd -i --logger=files
/usr/bin/sssd -D -d 5 --logger=files



[root@ldapclient_on_off /]# cat /usr/lib/systemd/system/sssd.service
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

[Install]
WantedBy=multi-user.target
[root@ldapclient_on_off /]#