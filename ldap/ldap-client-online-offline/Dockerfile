# syntax=docker/dockerfile:1
FROM archlinux:latest

LABEL group="arch-ldap-client"


RUN pacman -Sy --noconfirm openldap vi nss-pam-ldapd sssd
# RUN pacman -Sy --noconfirm vi nano nss-pam-ldapd
# RUN pacman -Sy --noconfirm vi nano sssd

# COPY config.ldif /etc/openldap/config.ldif
# COPY ldap.conf /etc/openldap/ldap.conf
# COPY me.ldif /root/me.ldif
# COPY sslOptions.ldif /root/sslOptions.ldif

# COPY slapdcert.pem /root/slapdcert.pem
# COPY slapdkey.pem /root/slapdkey.pem




# COPY part1/allowpwchange.ldif /root/allowpwchange.ldif
# COPY part1/base.ldif /root/base.ldif
# COPY part1/manager.ldif /root/manager.ldif
# COPY part1/people_group.ldif /root/people_group.ldif
# COPY part1/user_joe.ldif /root/user_joe.ldif
# COPY part1/group_joe.ldif /root/group_joe.ldif


COPY nss-config/nslcd.conf /etc/nslcd.conf


# COPY pam-auth/su-l /etc/pam.d/su-l
# COPY pam-auth/passwd /etc/pam.d/passwd
# COPY pam-auth/system-login /etc/pam.d/system-login


# Client Setup
COPY sssd.conf /etc/sssd/sssd.conf
COPY nsswitch.conf /etc/nsswitch.conf
COPY system-auth /etc/pam.d/system-auth
COPY su /etc/pam.d/su
COPY sudo /etc/pam.d/sudo


COPY setup-service.sh /setup-service.sh

# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
