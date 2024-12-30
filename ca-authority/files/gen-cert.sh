#!/bin/bash

# set -x

# openssl ca -in dnsmaster.csr -keyfile /root/ca/private/cakey.pem -cert /root/ca/certs/cacert.pem -passin file:/root/ca/private/passphrase.txt -out dnsmaster.crt 

CERT_NAME=$1

CERT_FILE_NAME="/root/ca/certs/${CERT_NAME}.crt"
# CERT_CNF_NAME="/root/ca/requests/${CERT_NAME}.cnf"
CERT_CSR_NAME="/root/ca/requests/${CERT_NAME}.csr"

# echo $CERT_FILE_NAME


# check_files() {
#     if [[ -e ${CERT_CSR_NAME} && -e ${CERT_CNF_NAME} ]]; then
#         echo "Both files exist " $?
#     else 
#         echo "Error: One or both files missing (${CERT_CSR_NAME}) , (${CERT_CNF_NAME})" $?
#         exit 2
#     fi    
# }

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
    # openssl ca -in ${CERT_CSR_NAME} -config ${CERT_CNF_NAME} -keyfile /root/ca/private/cakey.pem -cert /root/ca/certs/cacert.pem -passin file:/root/ca/private/passphrase.txt -out ${CERT_FILE_NAME}
    openssl ca -in ${CERT_CSR_NAME} -keyfile /root/ca/private/cakey.pem -cert /root/ca/certs/cacert.pem -passin file:/root/ca/private/passphrase.txt -out ${CERT_FILE_NAME}
}


# [[ -e "/root/ca/certs/${CERT_FILE_NAME}" ]] && read REPLY echo "Certificate Exists. Do you want to overwrite? (Y/N)"
# [[ -e "/root/ca/certs/${CERT_FILE_NAME}" ]]

# FILE_EXIST_TEST=$?
# echo $FILE_EXIST_TEST

REPLY=""

# if [[ $FILE_EXIST_TEST -eq 0 ]]; then
if [[ -e ${CERT_FILE_NAME} ]]; then
    echo "Certificate Exists. Do you want to proceed? (Y/N)"
    read REPLY
    if [[ $REPLY == "Y" || $REPLY == "y" ]]; then
        gen_cert
    else
        echo "Answer is not Y thus exiting..."
        exit 1
    fi
else
    gen_cert
fi

exit 0

# case $FILE_EXIST_TEST in
#     0) echo "Certificate Exists. Do you want to overwrite? (Y/N)" && read REPLY;;
#     *) ;;
# esac

# case $REPLY in
#     Y) ;;
#     y) ;;
#     *) echo "Answer is not Y thus exiting..." && exit 0 ;;
# esac

# [[ -e "/root/ca/certs/${CERT_CSR_NAME}" && -e "/root/ca/certs/${CERT_CNF_NAME}" ]]

# echo "Files " $?


# echo "Generating Certificate"