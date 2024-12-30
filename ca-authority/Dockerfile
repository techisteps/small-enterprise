# syntax=docker/dockerfile:1

FROM archlinux:latest

LABEL group="arch-dns-server"
LABEL group.role="arch-dns-server-master"


RUN pacman -Sy --noconfirm openssl openssh ntp


COPY files/setup-service.sh /setup-service.sh

### Changed CA default dir and policy_match
COPY files/openssl.cnf /etc/ssl/openssl.cnf
COPY files/gen-cert.sh /gen-cert.sh

### Pregenerated CA files
# COPY files/passphrase.txt /root/ca/private/passphrase.txt
# COPY files/cakey.pem /root/ca/private/cakey.pem
# COPY files/openssl_new_cacert.cnf /root/ca/requests/openssl_new_cacert.cnf
# COPY files/cacert.pem /root/ca/certs/cacert.pem



# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
