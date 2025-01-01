# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

LABEL group="ubuntu-krb5"

# docker rm $(docker ps -aq)
# docker buildx build -t kssh:v1 .
# docker run -dit --net=krb5 --name kssh --hostname kssh.jai.net -p 2222:22 kssh:v1 /bin/bash
# docker attach kssh

# docker exec kssh service krb5-kdc start
# docker exec kssh service krb5-admin-server start

# Update the package list and install the necessary packages
RUN apt-get update && apt-get install -yq openssh-server krb5-user libpam-krb5 libpam-ccreds nano iputils-ping nmap vim
# RUN useradd jai && echo "jai:jai" | chpasswd

COPY krb5.conf /etc/krb5.conf
# COPY kdc.conf /etc/krb5kdc/kdc.conf
# COPY kadm5.acl /etc/krb5kdc/kadm5.acl
COPY sshd_config /etc/ssh/sshd_config
COPY setup-service.sh /setup-service.sh

# RUN kdb5_util create -s -r JAI.NET -P jai
# RUN kadmin.local -q 'addprinc -pw jai admin/admin'
# RUN kadmin.local -q 'addprinc -pw jai root/admin'
# RUN kadmin.local -q 'addprinc -pw jai testuser/user'
# krb5kdc

# SHELL ["/bin/bash", "-c"]
# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
# && ["krb5kdc"] && ["/bin/bash"]

