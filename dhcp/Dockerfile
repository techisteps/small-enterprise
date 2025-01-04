# syntax=docker/dockerfile:1
FROM archlinux:latest

LABEL group="arch-dhcp-server"
LABEL group.role="arch-dhcp-server-master"


RUN pacman -Sy --noconfirm vi openssl kea nmap

RUN mkdir /kea-config

COPY kea-config/kea-dhcp4.conf /kea-config/kea-dhcp4.conf
COPY setup-service.sh /setup-service.sh


# CMD ["cd", "/", "&&", "./setup-service.sh", ">", "./setup-service.log"]


# FROM ubuntu:24.04

# LABEL group="ubuntu-dhcp-server"
# LABEL group.role="ubuntu-dhcp-server-master"


# RUN apt update && apt install iputils-ping nmap vim iproute2 -yq