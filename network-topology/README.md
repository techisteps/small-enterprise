# Networking Topology

In this tutorial we'll create a network topology with 5 VBOX VM's. Please refer to the `NetworkDiagram.drawio` file for further details. This file can be open with `https://app.diagrams.net/`.

We have to create 5 Vbox Vm's. This will be tedious thus we'll create a baseApline image and clone it to create 5 Vbox Vm's.

## Create VM's

0. baseAlpine
    - name: `baseAlpine`
    - CPU: `1`
    - Ram: `1024 MB`
    - Disk: `500 MB`
    - OS: `Alpine Linux`
    - Network1: **NAT**


We'll create 5 Vbox Vm's named mentioned below and without disk as we'll attach the cloned baseAlpine image to it.:
1. inetPC
    - name: `inetpc`
    - CPU: `1`
    - Ram: `1024 MB`
    - OS: `Alpine Linux`
    - Network1: **NAT**
    - Network2: **Internal Network**
    - - Name: `dept1net`
    - Network3: **Internal Network**
    - - Name: `dept2net`
2. dept1
    - name: `dept1`
    - CPU: `1`
    - Ram: `1024 MB`
    - OS: `Alpine Linux`
    - Network1: **NAT**
    - Network2: **Internal Network**
    - - Name: `dept1net`
    - Network3: **Internal Network**
    - - Name: `dept1labnet`
3. dept2
    - name: `dept2`
    - CPU: `1`
    - Ram: `1024 MB`
    - OS: `Alpine Linux`
    - Network1: **NAT**
    - Network2: **Internal Network**
    - - Name: `dept2net`
    - Network3: **Internal Network**
    - - Name: `dept2labnet`
4. dept1lab1
    - name: `dept1lab1`
    - CPU: `1`
    - Ram: `1024 MB`
    - OS: `Alpine Linux`
    - Network1: **NAT**
    - Network2: **Internal Network**
    - - Name: `dept1labnet`
5. dept2lab2
    - name: `dept2lab2`
    - CPU: `1`
    - Ram: `1024 MB`
    - OS: `Alpine Linux`
    - Network1: **NAT**
    - Network2: **Internal Network**
    - - Name: `dept2labnet`
---

## Install Alpine Linux (baseAlpine)
Install Alpine Linux on each of the Vbox Vm's. Please follow given instructions at: `https://wiki.alpinelinux.org/wiki/Installation`  
or  
`https://github.com/techisteps/jaiLFS/blob/main/LFS/00_Setup_VBOX.md#install-alpine`  
or  
`https://www.alpinelinux.org/`


## Network Setup (baseAlpine)
> On VBOX, I have setup port forwarding for this machine to enable ssh access.  
> Check if SSHD running by running the following command:  
> `rc.service sshd status` if not running run the following command:  
> `rc.service sshd start` if not setup run the following command:  
> `setup-sshd`

Once installation is complete reboot the system and setup network if not already done.
Login as root and run the following command to setup the network:  
`
setup-interfaces
`

Use below details to setup all machines.

1. baseAlpine
    - Network1: **NAT**
    - - Method: `DHCP`


## Download Packages on `baseAlpine`
Download network realated packages on inetPC. Later these packages will be installed on each of the VM's.

```bash
# Create folder to hold packages
mkdir /root/packages

# Change directory
cd /root/packages

# Update package list
apk update

# Download packages
apk fetch apache2-utils bash bind-tools bridge-utils busybox-extras conntrack-tools curl drill ethtool file fping iftop iperf3 iproute2 ipset iptables iputils ipvsadm jq libc6-compat ltrace net-snmp-tools netcat-openbsd nftables ngrep nmap nmap-nping nmap-scripts openssl py3-setuptools socat speedtest-cli openssh strace tcpdump util-linux vim git zsh perl-crypt-ssleay perl-net-ssleay

```

Create a script `install.sh` and copy below code to the script.

```bash
#!/bin/sh

for filename in /root/packages/*.apk; do
  #echo $filename
  #echo $(basename $filename)
  apk add $(basename $filename)
done
```

Update permissions
```bash
chmod +x install.sh
```

Execute the script to install the packages. 
```bash
./install.sh
```

## Other VM Setup
Once installation is complete poweroff the system and clone the baseAlpine 
disk image `baseAlpine.vdi`, 5 time for 5 Vbox Vm's and attache to respective Vm.

| Source Disk Image | Target Disk Image |
|---|---|
| baseAlpine.vdi | inetpc.vdi |
| baseAlpine.vdi | dept1.vdi |
| baseAlpine.vdi | dept2.vdi |
| baseAlpine.vdi | dept1lab1.vdi |
| baseAlpine.vdi | dept2lab2.vdi |


## Update Hostname
Update hostname for each of the Vm's. Run the following commands:
```bash
setup-hostname inetpc
hostname -F /etc/hostname
```
Repeat the above command for each of the Vm's.


## Network Setup
Login as root and run the following command to setup the network:  
```bash
setup-interfaces -r

#or 

setup-interfaces
rc.service networking restart
```

Use below details to setup all machines.

1. inetPC [Refer "./inetpc/interfaces"](inetpc/interfaces)
    - Network1: **NAT**
    - - Method: `DHCP`
    - Network2: **Internal Network**
    - - Method: `Static`
    - Network3: **Internal Network**
    - - Method: `Static`

>    Test:  
>        `ping 8.8.8.8` should be working as this machine has NAT setup on VBOX.  

2. dept1 [Refer "./dept1/interfaces"](dept1/interfaces)
    - Network1: **Internal Network**
    - - Method: `Static`
    - Network2: **Internal Network**
    - - Method: `Static`

>    Test:  
>        From dept1 `ping 192.168.1.1` should be working.  
>        From inetPC `ping 192.168.1.2` should be working.  

3. dept2 [Refer "./dept2/interfaces"](dept2/interfaces)
    - Network1: **Internal Network**
    - - Method: `Static`
    - Network2: **Internal Network**
    - - Method: `Static`

>    Test:  
>        From dept2 `ping 192.168.2.1` should be working.  
>        From inetPC `ping 192.168.2.2` should be working. 
>        From dept2 `ping 192.168.1.1` should be working as interface is physically attached to the gateway.   
>        From dept2 `ping 192.168.1.2` should not be working as there is no route to that interface. Routing well be setup later.   

4. dept1lab1 [Refer "./dept1lab1/interfaces"](dept1lab1/interfaces)
    - Network1: **Internal Network**
    - - Method: `Static`

>    Test:  
>        From dept1lab1 `ping 172.16.1.1` should be working.  
>        From dept1lab1 `ping 192.168.1.2` should be working as interface is physically attached to the gateway.  
>        From dept1lab1 `ping 192.168.1.1` should not work as there is no route to that interface. Routing well be setup later.   
>        From dept1 `ping 172.16.1.2` should be working.  



5. dept2lab2 [Refer "./dept2lab2/interfaces"](dept2lab2/interfaces)
    - Network1: **Internal Network**
    - - Method: `Static`

>    Test:  
>        From dept2lab2 `ping 172.16.2.1` should be working.  
>        From dept2lab2 `ping 192.168.2.2` should be working as interface is physically attached to the gateway.  
>        From dept2lab2 `ping 192.168.2.1` should not work as there is no route to that interface. Routing well be setup later.   
>        From dept2 `ping 172.16.2.2` should be working.  
