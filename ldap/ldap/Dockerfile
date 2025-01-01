# syntax=docker/dockerfile:1
FROM archlinux:latest

LABEL group="arch-krb5"


# RUN pacman -Sy --noconfirm openldap vi nss-pam-ldapd sssd
RUN pacman -Sy --noconfirm openldap vi nss-pam-ldapd

COPY config.ldif /etc/openldap/config.ldif
COPY ldap.conf /etc/openldap/ldap.conf
COPY me.ldif /root/me.ldif
COPY sslOptions.ldif /root/sslOptions.ldif

COPY slapdcert.pem /root/slapdcert.pem
COPY slapdkey.pem /root/slapdkey.pem

COPY setup-service.sh /setup-service.sh


COPY part1/allowpwchange.ldif /root/allowpwchange.ldif
COPY part1/base.ldif /root/base.ldif
COPY part1/manager.ldif /root/manager.ldif
COPY part1/people_group.ldif /root/people_group.ldif
COPY part1/user_joe.ldif /root/user_joe.ldif
COPY part1/group_joe.ldif /root/group_joe.ldif
# Client Setup
COPY part2-online/nsswitch.conf /etc/nsswitch.conf
COPY part2-online/nslcd.conf /etc/nslcd.conf
COPY part2-online/system-auth /etc/pam.d/system-auth
COPY part2-online/su /etc/pam.d/su
COPY part2-online/su-l /etc/pam.d/su-l
COPY part2-online/passwd /etc/pam.d/passwd
COPY part2-online/system-login /etc/pam.d/system-login
COPY part2-online/sudo /etc/pam.d/sudo
# COPY part2/sssd.conf /etc/sssd/sssd.conf


# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
