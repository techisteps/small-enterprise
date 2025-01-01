# syntax=docker/dockerfile:1
FROM archlinux:latest

LABEL group="arch-dns-server"
LABEL group.role="arch-dns-server-master"


RUN pacman -Sy --noconfirm vi openssl bind


# COPY setup-service.sh /setup-service.sh
# COPY cacert.pem /cacert.pem
# COPY dnsmaster.crt /dnsmaster.crt


# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]
