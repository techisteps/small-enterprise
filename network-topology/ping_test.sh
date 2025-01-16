#!/bin/bash

# set -x
RULE=""
IFACE=""
T_IP=""
V_HOST=""

testping() {
    ping -4 -n -c1 -I $IFACE $T_IP > /dev/null 2>&1
    if [[ $? == 0 ]]; then
        echo $RULE "PASS" | tee -a ./Results.txt
    else
        echo $RULE "FAIL" | tee -a ./Results.txt
    fi
}

while read -r line; do
    RULE=$(echo "$line" | cut -d"|" -f2)
    V_HOST=$(echo "$line" | cut -d"|" -f3 | tr -d '[:space:]')
    IFACE=$(echo "$line" | cut -d"|" -f4)
    T_IP=$(echo "$line" | cut -d"|" -f7)


    if [[ $V_HOST == `hostname` ]]; then
        echo Checking $RULE from $IFACE to $T_IP
        testping
    fi
   

done < ./ping_list.txt;