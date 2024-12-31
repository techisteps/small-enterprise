# CA Authority

## Setup CA Authority
### Using Scripts
To setup fresh CA Authority, run the following command:

```bash
rm -rf ./ca
docker compose up --remove-orphans --wait --build
docker exec caauthority /setup-environment.sh
docker exec caauthority /setup-service.sh
```

### Manually

If you want setup manually step by step then run the following command:

```bash
# If need fresh installation than remove existing CA files
rm -rf ./ca

# Run container
docker compose up --remove-orphans --wait --build && docker attach caauthority

# Setup environment
bash /setup-environment.sh


# Gerate Passfile
echo "super secret" > /root/ca/private/passphrase.txt

# Generate Private Key using passfile
openssl genrsa -aes256 -passout file:/root/ca/private/passphrase.txt -out /root/ca/private/cakey.pem 4096

# Check the private key
openssl rsa -in /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -check -noout

# Generate CA Config file
cat >> /root/ca/requests/openssl_new_cacert.cnf <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name
x509_extensions = v3_ca

[ req_distinguished_name ]
C = AU
ST = NSW
L = Wenty
O = JAI.NET
OU = systems
CN = caauthority.jai.net
emailAddress = admin@caauthority.jai.net

[ v3_ca ]

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical,CA:true
EOF



#Generate CA Certificate
# openssl req -config /etc/ssl/openssl.cnf -extensions v3_ca -key /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -new -x509 -days 3650 -out /root/ca/certs/cacert.pem
openssl req -config /root/ca/requests/openssl_new_cacert.cnf -extensions v3_ca -key /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -new -x509 -days 3650 -out /root/ca/certs/cacert.pem

# Check the certificate
openssl x509 -in /root/ca/certs/cacert.pem -noout -nocert -text

```


### Additional Files
Individual files can be overwritten by uncommenting COPY commands in Dockerfile.
```Dockerfile
### Pregenerated CA files
# COPY files/passphrase.txt /root/ca/private/passphrase.txt
# COPY files/cakey.pem /root/ca/private/cakey.pem
# COPY files/openssl_new_cacert.cnf /root/ca/requests/openssl_new_cacert.cnf
# COPY files/cacert.pem /root/ca/certs/cacert.pem
```

Once the CA Authority is setup, you can generate a certificate for any service. `ca` folder in the current project directory is mounted to `/root/ca` and contains the CA Authority files. It's always a good idea to keep strong backup policy for the CA files.


## Generate CSR
To generate a new CSR file, run the following command on the **host machine for which certificate is being generated**:

```bash
# First generate private key (Read explanation below in the README.md file)
openssl genrsa -aes256 -out dnsmaster.pem 2048
# Then generate CSR (Use sample config file "openssl_new_cacert.cnf")
openssl req -new -config openssl_new_cacert.cnf -days 3650 -key dnsmaster.pem -out dnsmaster.csr
```
Copy above generated CSR file to `/root/ca/requests` folder on CA authority server.


### Generate Certificate
To generate a new certificate, place the CSR file in `/root/ca/requests` folder and run the following command:

Run container and generate the Client CSR.

```bash
# Run container
docker compose up --remove-orphans --wait --build && docker attach caauthority

# Setup environment
# bash /setup-environment.sh

# Generate Private Key
openssl genrsa -out /root/ca/private/dnsmaster.pem 2048

### Option 1 ###
# Copy sample config file "sample_dnsmaster.cnf" as "dnsmaster.cnf" to "/root/ca/requests" folder and edit respectivly
cp sample_dnsmaster.cnf /root/ca/requests/dnsmaster.cnf

### Option 2 ###
#Or manually create the config file
cat >> /root/ca/requests/dnsmaster.cnf <<EOF
[ req ]
prompt = no
distinguished_name  = req_distinguished_name
req_extensions      = req_ext

[ req_distinguished_name ]
C = AU
ST = NSW
L = Wenty
O = JAI.NET
OU = systems
CN = dnsmaster.jai.net
emailAddress = admin@dnsmaster.jai.net

[ req_ext ]
subjectAltName      = @alt_names

[ alt_names ]
DNS.1   = dnsmaster.jai.net
IP.1    = 172.28.0.12
EOF


# Generate Client CSR
openssl req -new -key /root/ca/private/dnsmaster.pem -sha256 -config /root/ca/requests/dnsmaster.cnf -out /root/ca/requests/dnsmaster.csr

# Chekc Client CSR
openssl req -in /root/ca/requests/dnsmaster.csr -noout -text

```

Generate a new certificate, place the CSR file in `/root/ca/requests` folder and run the following command:

***Option 1***  
Generate certificate from scripts.

```bash
#docker compose up --remove-orphans --wait --build 
docker exec caauthority /gen-cert.sh dnsmaster y
```

***Option 2***  
Generate certificate manualy step by step.

```bash

# Generate Certificate
#openssl ca -config /etc/ssl/openssl.cnf -notext -in /root/ca/certs/dnsmaster.csr -extensions /root/ca/requests/dnsmaster.cnf -passin file:/root/ca/private/passphrase.txt -out /root/ca/certs/dnsmaster.crt -cert /root/ca/certs/cacert.pem -keyfile /root/ca/private/cakey.pem 
openssl ca -config /etc/ssl/openssl.cnf -notext -in /root/ca/certs/dnsmaster.csr -passin file:/root/ca/private/passphrase.txt -out /root/ca/certs/dnsmaster.crt -cert /root/ca/certs/cacert.pem -keyfile /root/ca/private/cakey.pem

# Check the certificate 
openssl x509 -in /root/ca/certs/dnsmaster.crt -noout -text

```

The above command will generate the certificate in `/root/ca/certs` folder.


### Add CA Certificate to clients system truststore

Copy the generated certificate and CA certificate to the client machine.
In this example `cacert.pem` and `dnsmaster.crt` are copied to the client machine.
Run below given `trust` commands on the client machine to add the CA certificate to the system truststore.

```bash
# docker cp caauthority:/root/ca/certs/dnsmaster.crt dnsmaster.crt
# docker cp dnsmaster.crt dnsmaster:/dnsmaster.crt
# docker cp caauthority:/root/ca/certs/cacert.pem cacert.pem
# docker cp cacert.pem dnsmaster:/cacert.pem

# Add CA Certificate to system truststore
trust anchor --store /cacert.pem

# Check CA Certificate in system truststore
ls -lrt /etc/ca-certificates/trust-source/caauthority.jai.net*
ls -lrt /etc/ca-certificates/trust-source/caauthority.jai.net.p11-kit

# Check CA Certificate
trust list | head A -20
trust list | grep -A 10 -B 10 caauthority

# Check CA Certificate format
trust check-format /etc/ca-certificates/trust-source/caauthority.jai.net.p11-kit


# ONce CA Certificate is added to system truststore, we can verify certificates
openssl verify /cacert.pem
openssl verify /dnsmaster.crt

```


## Useful Commands

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
[Youtube: CA Server - OpenSSL](https://www.youtube.com/watch?v=nOSl4dmywe8)  
[Wiki: Transport_Layer_Security](https://wiki.archlinux.org/title/Transport_Layer_Security)  
[Youtube: OpenSSL Certification Authority (CA) on Ubuntu Server](https://www.youtube.com/watch?v=oCl0gzLPPMI)  
[Wiki: NTP](https://wiki.archlinux.org/title/Network_Time_Protocol_daemon)  
[Easy-RSA](https://wiki.archlinux.org/title/Easy-RSA)  
[Archlinux News - CA Certificates Update](https://archlinux.org/news/ca-certificates-update/)  
[Archlinux help to install ca-certificates](https://unix.stackexchange.com/questions/373492/installing-certificates-on-arch)  
[Archlinux artical to install ca-certificates](https://wiki.archlinux.org/title/User:Grawity/Adding_a_trusted_CA_certificate)  

For Error Messages:  
[Error while configuring Certificate Authority server](https://groups.google.com/g/vglug/c/us3f5Ac-jaU)  


### Explanations:
- genrsa:

genrsa is used to generate RSA private key.

```bash
# Before generating private key of 512 bits
openssl genrsa 512

#but becuse we need strong encryption thus we'll use generate a private key with 4096 bits
openssl genrsa 4096

# and save the output to a location with
openssl genrsa 4096 > /root/ca/private/cakey.pem
## or
openssl genrsa -out /root/ca/private/cakey.pem 4096

# We also have to protect private key with passphrase so no one can read it without passphrase.
# We can use -aes256 to enforce password to be entered at the time of key generation.
openssl genrsa -aes256 -out /root/ca/private/cakey.pem 4096 
#or
# We can also use -passout option to pass passphrase from file instead of typing it.
openssl genrsa -aes256 -passout file:/root/ca/private/passphrase.txt -out /root/ca/private/cakey.pem 4096


# Need to verify the private key. This is used to verify the integrity of the private key.
## This option will only check the integrity of the key.
openssl rsa -in /root/ca/private/cakey.pem -check -noout

## Or this option will check the integrity of the key and will also print the key details with key, if the key is valid.
openssl rsa -in /root/ca/private/cakey.pem -check -text

## Or this option will check the integrity of the key and will also print the key details but not the key, if the key is valid.
openssl rsa -in /root/ca/private/cakey.pem -check -text -noout

## we can also pass passphrase from file
openssl rsa -in /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -check -noout

#or 
cat /root/ca/private/cakey.pem
 
```