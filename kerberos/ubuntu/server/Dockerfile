# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

LABEL group="ubuntu-krb5"

RUN apt-get update && apt-get install -yq krb5-kdc krb5-admin-server nano iputils-ping nmap vim

COPY krb5.conf /etc/krb5.conf
COPY kdc.conf /etc/krb5kdc/kdc.conf
COPY kadm5.acl /etc/krb5kdc/kadm5.acl
COPY k5login /root/.k5login
COPY setup-service.sh /setup-service.sh


# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
