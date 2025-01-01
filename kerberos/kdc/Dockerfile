FROM archlinux:latest

LABEL group="arch-krb5"


RUN pacman -Sy --noconfirm krb5


COPY krb5.conf /etc/krb5.conf
COPY kdc.conf /var/lib/krb5kdc/kdc.conf
COPY kadm5.acl /var/lib/krb5kdc/kadm5.acl

RUN mkdir /var/krb5kdc

RUN kdb5_util -P jai -r JAI.NET create -s
RUN kadmin.local -q 'addprinc -pw jai jai@JAI.NET'
RUN kadmin.local -q 'addprinc -pw jai admin/admin@JAI.NET'
RUN kadmin.local -q 'addprinc -pw jai root/admin@JAI.NET'

RUN kadmin.local -q 'addprinc -randkey host/kdc.jai.net'
RUN kadmin.local -q 'ktadd host/kdc.jai.net'
