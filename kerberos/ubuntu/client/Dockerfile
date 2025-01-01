# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

LABEL group="ubuntu-krb5"

# docker rm $(docker ps -aq)
# docker buildx build -t kclient:v1 .
# docker run -dit --net=krb5 --name kclient --hostname kclient.jai.net kclient:v1 /bin/bash
# docker attach kclient

# Update the package list and install the necessary packages
RUN apt-get update && apt-get install -yq krb5-user openssh-client nano iputils-ping nmap vim


COPY krb5.conf /etc/krb5.conf
# COPY kdc.conf /etc/krb5kdc/kdc.conf
# COPY kadm5.acl /etc/krb5kdc/kadm5.acl
COPY ssh_config /etc/ssh/ssh_config
COPY setup-service.sh /setup-service.sh

# RUN kdb5_util create -s -r JAI.NET -P jai
# RUN kadmin.local -q 'addprinc -pw jai admin/admin'
# RUN kadmin.local -q 'addprinc -pw jai root/admin'
# RUN kadmin.local -q 'addprinc -pw jai testuser/user'
# krb5kdc

# SHELL ["/bin/bash", "-c"]
# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
# && ["krb5kdc"] && ["/bin/bash"]

# SHELL ["/bin/bash", "-c"]
# CMD ["service", "krb5-kdc", "start"] && ["service", "krb5-admin-server", "start"] && ["service", "--status-all"]

