#!/bin/bash

# set -x

print_msg() {

    echo "                                 "
    echo "---------------------------------"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "---------------------------------"
    echo "                                 "

}


###########
## Start ## Generate Private Key
###########

generate_keys() {

    print_msg "Generating Private Key"

    # Read explanation in README.md file.
    openssl genrsa -aes256 -passout file:/root/ca/private/passphrase.txt -out /root/ca/private/cakey.pem 4096
    # other options are stdin, pass:foobar, and file:filename

    # Check the private key
    openssl rsa -in /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -check -noout
    [[ $? -ne 0 ]] && echo "*** Key Error ***"

}

[[ -e /root/ca/private/cakey.pem ]] && echo "Private Key Exists"
[[ ! -e /root/ca/private/cakey.pem ]] && generate_keys

###########
### End ### Generate Private Key
###########


generate_csr_conf() {

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

}

[[ -e /root/ca/requests/openssl_new_cacert.cnf ]] && echo "CSR Config Exists"
[[ ! -e /root/ca/requests/openssl_new_cacert.cnf ]] && generate_csr_conf

sleep 1


###########
## Start ## Generate CA Certificate
###########

generate_cacert() {

    print_msg "Generating CA Certificate"

    openssl req -config /root/ca/requests/openssl_new_cacert.cnf -extensions v3_ca -key /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -new -x509 -days 3650 -out /root/ca/certs/cacert.pem

    # Check the certificate
    # openssl x509 -in /root/ca/certs/cacert.pem -text -noout
    openssl x509 -in /root/ca/certs/cacert.pem -noout -nocert
    [[ $? -ne 0 ]] && echo "*** Certificate Error ***"


}

[[ -e /root/ca/certs/cacert.pem ]] && echo "CA Certificate Exists"
[[ ! -e /root/ca/certs/cacert.pem ]] && generate_cacert

###########
### End ### Generate CA Certificate
###########


chmod 600 -R /root/ca/


testing() {
    print_msg "Testing Key and Certificate"

    openssl rsa -in /root/ca/private/cakey.pem -passin file:/root/ca/private/passphrase.txt -check -noout
    [[ $? -ne 0 ]] && return 1

    openssl x509 -in /root/ca/certs/cacert.pem -noout -nocert
    [[ $? -ne 0 ]] && return 2

    return 0
}

testing
[[ $? -ne 0 ]] && echo "Testing Failed" || echo "All test passed..."








#     1  update-ca-trust --help
#     2  pacman -Ss update-ca-certificates
#     3  trust --help
#     4  trust list
#     5  update-ca-trust --help
#     6  clear
#     7  trust list
#     8  trust list | grep type=cert | wc -l
#     9  trust --help
#    10  trust anchor --help
#    11  update-ca-trust --help
#    12  ls -lrt /etc/ca-certificates/extracted/
#    13  update-ca-trust
#    14  ls -lrt /etc/ca-certificates/extracted/
#    15  ls -lrt /etc/ca-certificates/extracted/cadir/
#    16  cd ..
#    17  history

# trust list | grep -A 10 -B 10 jai

#     1  trust anchor --store /root/ca/certs/cacert.pem
#     2  echo $?
#     3  cp /root/ca/certs/cacert.pem /root/ca/certs/cacert.crt
#     4  trust anchor --store /root/ca/certs/cacert.crt
#     5  echo $?
#     6  echo $?
#     7  trust --help
#     8  trust list | grep jai
#     9  trust list
#    10  trust list | grep -A 5 jai
#    11  trust list | grep -A 5 -B 5jai
#    12  trust list | grep -A 5 -B 5 jai
#    13  trust list | grep -A 10 -B 10 jai
#    14  clear
#    15  trust list | grep -A 10 -B 10 jai
#    16  trust list | head -5