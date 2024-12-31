#!/bin/bash

# set -x

print_msg() {

    echo "                                 "
    echo "---------------------------------"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "---------------------------------"
    echo "                                 "

}


print_msg "Starting NTP"
ntpd -u ntp:ntp
ps -ef
sleep 2 && ntpq -p

# echo *** Current Syatem Date - Before Sync***
# date

# /usr/bin/hwclock -w

# echo *** Current Syatem Date - After Sync***
# date

create_folders() {

    print_msg "Creating folders"
    mkdir -p /root/ca/{certs,crl,newcerts,newcrl,private,requests}
    touch /root/ca/index.txt
    # touch /root/ca/index.txt.attr
    # touch /root/ca/serial
    # touch /root/ca/crlnumber
}

# [[ ! -d /root/ca ]] && create_folders
create_folders

create_serial() {
    print_msg "Creating Serial Number"
    # openssl rand -hex 16 > /root/ca/serial
    echo 01 > /root/ca/serial
}

[[ -e /root/ca/serial ]] && echo "Serial Exists"
[[ ! -e /root/ca/serial ]] && create_serial


create_passfile() {
    print_msg "Generating Passfile"
    echo "super secret" > /root/ca/private/passphrase.txt
}

[[ -e /root/ca/private/passphrase.txt ]] && echo "Passfile Exists"
[[ ! -e /root/ca/private/passphrase.txt ]] && create_passfile

