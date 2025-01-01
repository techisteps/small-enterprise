FROM archlinux:latest

LABEL group="arch-krb5"


RUN pacman -Sy --noconfirm krb5 openssh vi

COPY krb5.conf /etc/krb5.conf
COPY ssh_config /etc/ssh/ssh_config
COPY sshd_config /etc/ssh/sshd_config
COPY k5login /root/.k5login

COPY setup-service.sh /setup-service.sh
