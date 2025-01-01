# Arch Linux Kerberos authentication

To test this solution, three system needs to be setup.  
|Server Name | Description |
|---|---|
| KDC | Kerberos server |
| Kclient | Will be used a client machine |
| KSSH | This will be running SSH service and shows an example how services authnticate using Kerberos |

`JAI.NET` is the default realm. `kdc`, `kssh` and `kclient` folders of this repo contains respective container code.


## Pre-requisites

As we are running 3 container and they have to communicate with each other, we need to create a common network. This will resolve our DNS rsolutions.  

> Create network if not already present.
```bash
docker network create krb5
```

## KDC setup
Build the image.
```bash
cd /mnt/c/DevBox/kerberos/archlinux/kdc
docker buildx build -t kdc:v1 .
```

Run the container.
```bash
docker run -dit --net=krb5 --name kdc --hostname kdc.jai.net kdc:v1 /bin/bash
```

Once container is started run below command to setup and start the Kerberos service.
```bash
docker exec kdc krb5kdc && docker exec kdc kadmind && docker exec kdc ps -ef
```

## Kssh (SSH service) setup

Build the image.
```bash
cd /mnt/c/DevBox/kerberos/archlinux/kssh
docker buildx build -t kssh:v1 .
```

Run the container.
```bash
docker run -dit --net=krb5 --name kssh --hostname kssh.jai.net kssh:v1 /bin/bash
```

Once container is started run below command to setup and start the SSH service.
```bash
docker exec kssh /setup-service.sh && docker exec kssh ps -ef
```


## Kclient setup

Build the image.
```bash
cd /mnt/c/DevBox/kerberos/archlinux/kclient
docker buildx build -t kclient:v1 .
```

Run the container.
```bash
docker run -dit --net=krb5 --name kclient --hostname kclient.jai.net kclient:v1 /bin/bash
```

Once container is started run below command to setup and start the SSH service. Though this container will run SSH service, we'll use it as client machine.
```bash
docker exec kclient /setup-service.sh && docker exec kclient ps -ef
```

## Test

Attach to kclient container and run below command.
```bash
docker attach kclient
```

Get Kerberos ticket from kdc server.
```bash
kinit jai
```

Check Kerberos ticket.
```bash
klist
```

Connect to kssh server.
```bash
ssh kssh.jai.net
```


## Trobleshooting

### Scenario 1:

```
[root@kclient ~]# ssh kssh.jai.net
root@kssh.jai.net: Permission denied (gssapi-with-mic).
```
If you get the above error on kclient container. This might be because of missing host entry in /etc/hosts file (DNS eror).

To test this, run below commands and validate the highlighed output.
```
[root@kclient ~]# ssh -vvv kssh.jai.net
.
.
.
debug1: Unspecified GSS failure.  Minor code may provide more information
Server krbtgt/KRB5@JAI.NET not found in Kerberos database
.
.
.
```
Above shows that service is trying to validate against a different service principal (krbtgt/KRB5@JAI.NET) instead of kssh.jai.net. Run the ping command and check its resolving to the correct IP address and DNS entry.

```
[root@kclient ~]# ping -c 2 kssh.jai.net
PING kssh.jai.net (172.19.0.3) 56(84) bytes of data.
64 bytes from kssh.krb5 (172.19.0.3): icmp_seq=1 ttl=64 time=0.072 ms
64 bytes from kssh.krb5 (172.19.0.3): icmp_seq=2 ttl=64 time=0.074 ms

--- kssh.jai.net ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 0.072/0.073/0.074/0.001 ms
```

To fix this error check the ip of container and add it to the /etc/hosts file.
```bash
# on host
docker inspect kssh | grep IPAddress
```

```bash
# on kclient
cat >> /etc/hosts <<EOL
172.19.0.3 kssh.jai.net
EOL
```


To be safer side you can add all IP's to all containers.

```bash
cat >> /etc/hosts <<EOL
172.19.0.2 kdc.jai.net
172.19.0.3 kclient.jai.net
172.19.0.4 kssh.jai.net
EOL
```


References:  
[Kerberos Arch Wiki](https://wiki.archlinux.org/title/Kerberos)  
[Kerberos OpenSsh Wiki](https://wiki.archlinux.org/title/OpenSSH)  