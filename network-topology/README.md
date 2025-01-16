# Networking Topology

In this tutorial we'll create a network topology with 5 VBOX VM's. Please refer to the `NetworkDiagram.drawio` file for further details. This file can be open with `https://app.diagrams.net/`.

## Objective
The objective of this tutorial is to create a network topology with 5 VBOX VM's and setup networking between them so that they can communicate with each other and can access internet.

- Step 1: Create 5 Vbox Vm's and setup network based on given diagram
- Step 2: Setup routing between Vbox Vm's
- Step 3: Setup NAT so that we can access internet from each of the Vbox Vm's

### The 3 most important steps are as below:

1. ***Setup interfaces:***  
    In this step we have to set `IP`, `Subnet`, `Gateway` to all network interfaces on each of the Vm's. This is based on how physically the network cards are attached. This means how the designated route can be reached.
2. ***Setup routing:***  
    If two network cards are physically attached with same cable then traffic can flow between them directly without any routing. If two network cards are attached to the same switch then we need to setup routing between them to allow traffic to flow.
    This step consist of `IP Forwarding` and `Routing`.
3. ***Setup NAT:***  
    Internet traffic for our network will flow from main router in this case `inetPC` Vm acting as router for our network. In this step we have to setup NAT so that we can access internet from each of the Vbox Vm's. NAT will translate our private IP to public IP and vice versa.

We have to create 5 Vbox Vm's. This will be tedious thus we'll create a `baseApline` image and clone it to create 5 Vbox Vm's.

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
Download network related packages on inetPC. Later these packages will be installed on each of the VM's.

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


Routes:

> ping pattern to test `ping -4 -n -c2 -I eth0 192.168.1.1`

| Route No.| PC Name| Source Interface | Source IP | Target IP| Default | IPF Run1 | IPF Run2 | IPF Run3 | IPF Run4 | IPF Run5 | With Routing |
|---|---|---|---|---|---|---|---|---|---|---|---|
|1 | inetpc    | eth1 | 192.168.1.1 | 192.168.1.2 | P | - | - | - | - | - | - |
|2 | inetpc    | eth1 | 192.168.1.1 | 192.168.2.1 | F | - | - | - | - | - | - |
|3 | inetpc    | eth1 | 192.168.1.1 | 192.168.2.2 | F | - | - | - | - | - | - |
|4 | inetpc    | eth1 | 192.168.1.1 | 172.16.1.1  | F | - | - | - | - | - | - |
|5 | inetpc    | eth1 | 192.168.1.1 | 172.16.1.2  | F | - | - | - | - | - | - |
|6 | inetpc    | eth1 | 192.168.1.1 | 172.16.2.1  | F | - | - | - | - | - | - |
|7 | inetpc    | eth1 | 192.168.1.1 | 172.16.2.2  | F | - | - | - | - | - | - |
|8 | inetpc    | eth2 | 192.168.2.1 | 192.168.1.1 | F | - | - | - | - | - | - |
|9 | inetpc    | eth2 | 192.168.2.1 | 192.168.1.2 | F | - | - | - | - | - | - |
|10| inetpc    | eth2 | 192.168.2.1 | 192.168.2.2 | P | - | - | - | - | - | - |
|11| inetpc    | eth2 | 192.168.2.1 | 172.16.1.1  | F | - | - | - | - | - | - |
|12| inetpc    | eth2 | 192.168.2.1 | 172.16.1.2  | F | - | - | - | - | - | - |
|13| inetpc    | eth2 | 192.168.2.1 | 172.16.2.1  | F | - | - | - | - | - | - |
|14| inetpc    | eth2 | 192.168.2.1 | 172.16.2.2  | F | - | - | - | - | - | - |
|15| dept1     | eth1 | 192.168.1.2 | 192.168.1.1 | P | P | P | P | P | P | - |
|16| dept1     | eth1 | 192.168.1.2 | 192.168.2.1 | P | P | P | P | P | P | - |
|17| dept1     | eth1 | 192.168.1.2 | 192.168.2.2 | F | P | F | F | F | P | - |
|18| dept1     | eth1 | 192.168.1.2 | 172.16.1.1  | F | F | F | F | F | F | - |
|19| dept1     | eth1 | 192.168.1.2 | 172.16.1.2  | F | F | F | F | F | F | - |
|20| dept1     | eth1 | 192.168.1.2 | 172.16.2.1  | F | F | F | F | F | F | - |
|21| dept1     | eth1 | 192.168.1.2 | 172.16.2.2  | F | F | F | F | F | F | - |
|22| dept1     | eth2 | 172.16.1.1  | 192.168.1.1 | F | F | F | F | F | F | - |
|23| dept1     | eth2 | 172.16.1.1  | 192.168.1.2 | F | F | F | F | F | F | - |
|24| dept1     | eth2 | 172.16.1.1  | 192.168.2.1 | F | F | F | F | F | F | - |
|25| dept1     | eth2 | 172.16.1.1  | 192.168.2.2 | F | F | F | F | F | F | - |
|26| dept1     | eth2 | 172.16.1.1  | 172.16.1.2  | P | P | P | P | P | P | - |
|27| dept1     | eth2 | 172.16.1.1  | 172.16.2.1  | F | F | F | F | F | F | - |
|28| dept1     | eth2 | 172.16.1.1  | 172.16.2.2  | F | F | F | F | F | F | - |
|29| dept2     | eth1 | 192.168.2.2 | 192.168.1.1 | P | P | P | P | P | P | - |
|30| dept2     | eth1 | 192.168.2.2 | 192.168.1.2 | F | P | F | F | F | P | - |
|31| dept2     | eth1 | 192.168.2.2 | 192.168.2.1 | P | P | P | P | P | P | - |
|32| dept2     | eth1 | 192.168.2.2 | 172.16.1.1  | F | F | F | F | F | F | - |
|33| dept2     | eth1 | 192.168.2.2 | 172.16.1.2  | F | F | F | F | F | F | - |
|34| dept2     | eth1 | 192.168.2.2 | 172.16.2.1  | F | F | F | F | F | F | - |
|35| dept2     | eth1 | 192.168.2.2 | 172.16.2.2  | F | F | F | F | F | F | - |
|36| dept2     | eth2 | 172.16.2.1  | 192.168.1.1 | F | F | F | F | F | F | - |
|37| dept2     | eth2 | 172.16.2.1  | 192.168.1.2 | F | F | F | F | F | F | - |
|38| dept2     | eth2 | 172.16.2.1  | 192.168.2.1 | F | F | F | F | F | F | - |
|39| dept2     | eth2 | 172.16.2.1  | 192.168.2.2 | F | F | F | F | F | F | - |
|40| dept2     | eth2 | 172.16.2.1  | 172.16.1.1  | F | F | F | F | F | F | - |
|41| dept2     | eth2 | 172.16.2.1  | 172.16.1.2  | F | F | F | F | F | F | - |
|42| dept2     | eth2 | 172.16.2.1  | 172.16.2.2  | P | P | P | P | P | P | - |
|43| dept1lab1 | eth1 | 172.16.1.2  | 192.168.1.1 | F | F | F | F | F | F | - |
|44| dept1lab1 | eth1 | 172.16.1.2  | 192.168.1.2 | P | P | P | P | P | P | - |
|45| dept1lab1 | eth1 | 172.16.1.2  | 192.168.2.1 | F | F | F | F | F | F | - |
|46| dept1lab1 | eth1 | 172.16.1.2  | 192.168.2.2 | F | F | F | F | F | F | - |
|47| dept1lab1 | eth1 | 172.16.1.2  | 172.16.1.1  | P | P | P | P | P | P | - |
|48| dept1lab1 | eth1 | 172.16.1.2  | 172.16.2.1  | F | F | F | F | F | F | - |
|49| dept1lab1 | eth1 | 172.16.1.2  | 172.16.2.2  | F | F | F | F | F | F | - |
|50| dept2lab2 | eth1 | 172.16.2.2  | 192.168.1.1 | F | F | F | F | F | F | - |
|51| dept2lab2 | eth1 | 172.16.2.2  | 192.168.1.2 | F | F | F | F | F | F | - |
|52| dept2lab2 | eth1 | 172.16.2.2  | 192.168.2.1 | F | F | F | F | F | F | - |
|53| dept2lab2 | eth1 | 172.16.2.2  | 192.168.2.2 | P | P | P | P | P | P | - |
|54| dept2lab2 | eth1 | 172.16.2.2  | 172.16.1.1  | F | F | F | F | F | F | - |
|55| dept2lab2 | eth1 | 172.16.2.2  | 172.16.1.2  | F | F | F | F | F | F | - |
|56| dept2lab2 | eth1 | 172.16.2.2  | 172.16.2.1  | P | P | P | P | P | P | - |


```bash
# Define routing table
ip route add 172.16.1.0/24 via 192.168.1.2
ip route add 172.16.2.0/24 via 192.168.2.2

# Save restored routing table
ip route restore ip_route.save
ip route restore < ./ip_route.save
```

<!-- ip route add 172.16.1.0/24 via 192.168.1.2 dev eth1
ip route add 172.16.2.0/24 via 192.168.2.2 dev eth1 -->

```bash
# Masquerading using IPTABLES
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

```bash
# To test the syntax of NFT file 
nft -c -f inetpc_nat.nft

# To apply the NFT file 
nft -f inetpc_nat.nft
```

Reference: 
https://www.mankier.com/8/nft#   
https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes  
https://www.netfilter.org/projects/nftables/manpage.html  
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/security_guide/sec-creating_and_managing_nftables_tables_chains_and_rules#sec-Creating_an_nftables_chain  
https://www.youtube.com/playlist?list=PLUF494I4KUvqwDjhOoP3IFUpgEhE1OVDO