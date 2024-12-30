#!/bin/bash

# set -x

CERT_NAME=$1
OVERWRITE_FLAG=$2

CERT_FILE_NAME="/root/ca/certs/${CERT_NAME}.crt"
CERT_CSR_NAME="/root/ca/requests/${CERT_NAME}.csr"

check_files() {
    if [[ -e ${CERT_CSR_NAME} ]]; then
        echo "CSR file exist" $?
    else 
        echo "Error: CSR file missing (${CERT_CSR_NAME})"
        exit 2
    fi    
}

gen_cert() {
    check_files
    echo "Generating Certificate"
    openssl ca -in ${CERT_CSR_NAME} -keyfile /root/ca/private/cakey.pem -cert /root/ca/certs/cacert.pem -passin file:/root/ca/private/passphrase.txt -out ${CERT_FILE_NAME}
}

if [[ $OVERWRITE_FLAG = "Y" || $OVERWRITE_FLAG = "y" ]]; then
    OVERWRITE_FLAG="Y"
else
    OVERWRITE_FLAG="N"
fi


if [[ -e ${CERT_FILE_NAME} ]]; then

    if [[ $OVERWRITE_FLAG = "Y" ]]; then
        gen_cert
    else 
        echo "Certificate Exists. If you want to proceed, pass Y as overwrite flag."
        exit 1
    fi

else
    gen_cert
fi

exit 0