#!/bin/bash


# mkdir /var/krb5kdc


kadmin -w jai -q 'addprinc -randkey host/kclient.jai.net'
kadmin -w jai -q 'ktadd host/kclient.jai.net'
# /usr/bin/ssh-keygen -A
# nohup /usr/bin/sshd -D -E /var/sshd.log &

# service ssh start
# service --status-all



# service krb5-kdc start
# service krb5-admin-server start
# service --status-all


#    3 jai@JAI.NET (aes256-cts-hmac-sha1-96)
#    3 jai@JAI.NET (aes128-cts-hmac-sha1-96)
#    3 host/kdc.jai.net@JAI.NET (aes256-cts-hmac-sha1-96)
#    3 host/kdc.jai.net@JAI.NET (aes128-cts-hmac-sha1-96)
#    3 host/kclient.jai.net@JAI.NET (aes256-cts-hmac-sha1-96)
#    3 host/kclient.jai.net@JAI.NET (aes128-cts-hmac-sha1-96)
#    3 host/kssh.jai.net@JAI.NET (aes128-cts-hmac-sha1-96)
#    2 host/kssh.krb5@JAI.NET (aes256-cts-hmac-sha1-96)
#    2 host/kssh.krb5@JAI.NET (aes128-cts-hmac-sha1-96)
#    2 krbtgt/KRB5@JAI.NET (aes128-cts-hmac-sha1-96)
#    3 host/kssh.jai.net@JAI.NET (aes256-cts-hmac-sha1-96)
#    2 krbtgt/KRB5@JAI.NET (aes256-cts-hmac-sha1-96)