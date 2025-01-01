#!/bin/bash


mkdir /var/krb5kdc

kdb5_util create -s -r JAI.NET -P jai
kadmin.local -q 'addprinc -pw jai admin/admin'
kadmin.local -q 'addprinc -pw jai root/admin'
# kadmin.local -q 'addprinc -pw jai testuser/user'
kadmin.local -q 'addprinc -pw jai jai'

# kadmin.local -q 'addprinc -randkey host/kssh.jai.net'
# kadmin.local -q 'addprinc -randkey host/kclient.jai.net'
kadmin.local -q 'addprinc -randkey host/kdc.jai.net'

# kadmin.local -q 'addprinc -randkey krbtgt/KRB5'
# kadmin.local -q 'addprinc -randkey host/kssh.krb5'
# kadmin.local -q 'addprinc -randkey host/kclient.krb5'

# kadmin.local -q 'ktadd -k /etc/krb5kdc/kadm5.keytab host/kssh.jai.net'
# kadmin.local -q 'ktadd -k /etc/krb5kdc/kadm5.keytab host/kclient.jai.net'

# kadmin.local -q 'ktadd host/kssh.jai.net'
# kadmin.local -q 'ktadd host/kclient.jai.net'
# kadmin.local -q 'ktadd jai'
# kadmin.local -q 'ktadd krbtgt/KRB5'
# kadmin.local -q 'ktadd host/kssh.krb5'
# kadmin.local -q 'ktadd host/kclient.krb5'


service krb5-kdc start
service krb5-admin-server start
service --status-all


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