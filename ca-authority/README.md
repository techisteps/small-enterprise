# CA Authority


### Setup CA Authority
To setup fresh CA Authority, run the following command:

```bash
rm -ef ./ca
docker compose up --remove-orphans --wait
docker exec caauthority /setup-service.sh
```

Individual files can be overwritten by uncommenting COPY commands in Dockerfile.
```Dockerfile
### Pregenerated CA files
# COPY files/passphrase.txt /root/ca/private/passphrase.txt
# COPY files/cakey.pem /root/ca/private/cakey.pem
# COPY files/openssl_new_cacert.cnf /root/ca/requests/openssl_new_cacert.cnf
# COPY files/cacert.pem /root/ca/certs/cacert.pem
```

Once the CA Authority is setup, you can generate a certificate for any service. `ca` folder in the current directory is mounted to `/root/ca` and contains the CA Authority files. It's always a good idea to keep strong backup policy for the CA files.


### Generate CSR
To generate a new CSR file, run the following command on the **host machine for which certificate is being generated**:

```bash
# openssl genrsa -aes256 -passout file:/root/ca/private/passphrase.txt -out /root/ca/private/cakey.pem 4096
# First generate private key
openssl genrsa -aes256 -out dnsmaster.pem 2048
# Then generate CSR (Use sample config file "openssl_new_cacert.cnf")
openssl req -new -config openssl_new_cacert.cnf -days 3650 -key dnsmaster.pem -out dnsmaster.csr
```
Copy above generated CSR file to `/root/ca/requests` folder on CA authority server.


### Generate Certificate
To generate a new certificate, place the CSR file in `/root/ca/requests` folder and run the following command:

```bash
docker compose up --remove-orphans --wait --build && docker exec caauthority /gen-cert.sh dnsmaster y

# or 

docker compose up --remove-orphans --wait --build 
docker exec caauthority /gen-cert.sh dnsmaster y

```

The above command will generate the certificate in `/root/ca/certs` folder.


### Add CA Certificate to system truststore
To add CA Certificate to system truststore, run the following command:

```bash
```



### Useful Commands

```bash
docker compose up --remove-orphans --wait
docker compose up --remove-orphans --wait --build
```

```bash
docker compose down --remove-orphans
```

```bash
docker attach caauthority
```

```bash
docker compose up --remove-orphans --wait --build && docker exec caauthority /setup-service.sh
docker compose up --remove-orphans --wait && docker exec caauthority /gen-cert.sh
docker compose up --remove-orphans --wait
docker exec caauthority /gen-cert.sh dnsmaster y
docker compose up --remove-orphans --wait --build && docker attach caauthority
```


### Useful Links:
[Wiki: Transport_Layer_Security](https://wiki.archlinux.org/title/Transport_Layer_Security)  
[Youtube: OpenSSL Certification Authority (CA) on Ubuntu Server](https://www.youtube.com/watch?v=oCl0gzLPPMI)  
[Wiki: NTP](https://wiki.archlinux.org/title/Network_Time_Protocol_daemon)  
[Easy-RSA](https://wiki.archlinux.org/title/Easy-RSA)  
[Archlinux News - CA Certificates Update](https://archlinux.org/news/ca-certificates-update/)  
[Archlinux help to install ca-certificates](https://unix.stackexchange.com/questions/373492/installing-certificates-on-arch)  
[Archlinux artical to install ca-certificates](https://wiki.archlinux.org/title/User:Grawity/Adding_a_trusted_CA_certificate)  

For Error Messages:  
[Error while configuring Certificate Authority server](https://groups.google.com/g/vglug/c/us3f5Ac-jaU)  