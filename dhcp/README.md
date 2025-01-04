
```bash
docker network create --driver bridge --subnet=172.50.0.0/16 --gateway=172.50.0.1 --label name=dhcp_net dhcp_net
```

```bash
docker compose up --remove-orphans --wait
docker compose up --remove-orphans --wait --build
docker exec -it dhcpmaster /bin/bash
```

```bash
docker compose down --remove-orphans
```

```bash
docker attach dhcpmaster
```

```bash
docker compose up --remove-orphans --wait --build && docker exec dhcpmaster /setup-service.sh
docker compose up --remove-orphans --wait --build && docker attach dhcpmaster
```

```bash
# openssl genrsa -aes256 -passout file:/root/ca/private/passphrase.txt -out /root/ca/private/cakey.pem 4096
openssl genrsa -aes256 -out dhcpmaster.pem 2048
openssl req -new -config openssl_new_cacert.cnf -days 3650 -key dhcpmaster.pem -out dhcpmaster.csr
```

```bash

kea-dhcp4 -t /etc/kea/kea-dhcp4.conf

keactrl start -s dhcp4
keactrl status -s dhcp4

```

<!-- /usr/bin/kea-dhcp4 -c /etc/kea/kea-dhcp4.conf > /var/log/kea-dhcp4.log 2>&1 &; echo $! > /var/run/kea-dhcp4.pid -->


Testing:
docker run -dit --rm --name nettest --network dhcp_net nicolaka/netshoot && docker exec -it nettest /bin/bash
docker run -dit --rm --name nettest --network dhcp_net ubuntu:24.04 && docker exec -it nettest /bin/bash
docker run -dit --rm --name nettest --network dhcp_net --cap-add=NET_ADMIN ubuntu:24.04 && docker exec -it nettest /bin/bash


docker run -dit --rm --name nettest --network dhcp_net --mac-address 1a:1b:1c:1d:1e:1f --cap-add=NET_ADMIN ubuntu:24.04 && docker exec -it nettest /bin/bash
apt update && apt install iputils-ping nmap iproute2 isc-dhcp-client -yq

docker run -dit --rm --name nettest1 --network dhcp_net --mac-address 1a:1a:1a:1a:1a:1a --cap-add=NET_ADMIN ubuntu:24.04 && docker exec -it nettest1 /bin/bash
apt update && apt install iputils-ping nmap iproute2 isc-dhcp-client -yq




Ref: https://linux.die.net/man/7/capabilities
cmd 1 - dhclient -s 172.50.0.5 
cmd 2 - echo $! 
cmd 3 - getpcaps --verbose <hear> ## Place process ID in place of <hear>
Another option cat /proc/<hear>/status | grep Cap


    1  ip -c a
    2  ip link set dev eth0 down
    3  ip link set dev eth0 down
    4  whoami
    5  ip -c a
    6  dhcping -?
    7  dhcping -v
    8  dhcping -iv
    9  dhcping -riv
   10  dhcping -rv
   11  dhcping -v -c 172.50.0.10
   12  dhcping -v -c 172.50.0.10 -s 172.50.0.5
   13  ip -c a
   14  uname
   15  pacman
   16  apt
   17  apk
   18  apk add dhclient
   19  dhclient --help
   20  dhclient
   21  service
   22  ps -ef
   23  kill -9 102
   24  ps -ef
   25  dhclient --help
   26  dhclient -s 172.50.0.5
   27  ps -ef
   28  ip -c a
   29  cat /etc/resolv.conf
   30  exit
   31  history





/usr/bin/kea-dhcp4 -c /etc/kea/kea-dhcp4.conf > /var/log/kea-dhcp4.log 2>&1 &
kill -9 `cat /var/run/kea/kea-dhcp4.kea-dhcp4.pid`







kea-ctrl-agent -c /etc/kea/kea-ctrl-agent.conf &


curl -X POST -H "Content-Type: application/json" -d '{ "command": "list-commands" }' http://127.0.0.1:8000/
[ { "arguments": [ "build-report", "config-get", "config-hash-get", "config-reload", "config-set", "config-test", "config-write", "list-commands", "shutdown", "status-get", "version-get" ], "result": 0 } ]

curl -X POST -H "Content-Type: application/json" -d '{ "command": "config-test" }' http://127.0.0.1:8000/
[ { "result": 1, "text": "Missing mandatory 'arguments' parameter." } ]

curl -X POST -H "Content-Type: application/json" -d '{ "command": "status-get" }' http://127.0.0.1:8000/
[ { "arguments": { "pid": 85, "reload": 667, "uptime": 667 }, "result": 0 } ]





kea-shell --host localhost --auth-user] [--auth-password] [--timeout seconds] [--service service-name] [command]


pacman -Ql bind | grep -v -e include -e share -e lib

/usr/bin/named -f -u named
nohup /usr/bin/named -f -u named > /var/log/named.log 2>&1 &

/usr/bin/named -4 -d 5 -g -u named -L /var/log/named.log1

/usr/bin/named -4 -d 5 -u named -L /var/log/named.log1
cat /var/run/named/named.pid

dig -t AXFR google.com @127.0.0.1
dig -t google.com @127.0.0.1

[root@dnsmaster ~]# cat /usr/lib/systemd/system/named.service
[Unit]
Description=Internet domain name server
After=network.target

[Service]
ExecStart=/usr/bin/named -f -u named
ExecReload=/usr/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target




[named](https://bind9.readthedocs.io/en/v9.18.14/manpages.html#named-internet-domain-name-server)
[Arch BIND](https://wiki.archlinux.org/title/BIND)
[Arch named.conf](https://man.archlinux.org/man/named.conf.5)
https://bind9.readthedocs.io/en/latest/chapter3.html
