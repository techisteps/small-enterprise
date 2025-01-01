#!/bin/bash


set -x 

# PART 2.2 - Client Setup - Online

chmod 0600 /etc/nslcd.conf
# nohup /usr/bin/nslcd --nofork &
nohup /usr/bin/nslcd --debug > /var/log/nslcd.log 2>&1 &
ps -ef
