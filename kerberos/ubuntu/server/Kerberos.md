Certainly! I'll guide you through the process of setting up Kerberos on Ubuntu 24.04 containers. We'll create three containers: one for the Kerberos server, one for the client, and one for a service that requires Kerberos authentication.

## Step 1: Set up the Kerberos Server Container

1. Create a Docker container for the Kerberos server:
```bash
docker run -d --name kerberos-server --hostname kdc.example.com ubuntu:24.04
```

2. Access the container:
```bash
docker exec -it kerberos-server /bin/bash
```

3. Update and install necessary packages:
```bash
apt update
apt install -y krb5-kdc krb5-admin-server
```

4. Configure the Kerberos realm:
```bash
krb5_newrealm
```
When prompted, enter a password for the database.

5. Edit the Kerberos configuration file:
```bash
nano /etc/krb5.conf
```
Add the following under the [realms] section:
```
EXAMPLE.COM = {
    kdc = kdc.example.com
    admin_server = kdc.example.com
}
```

6. Create a principal for administration:
```bash
kadmin.local -q "addprinc admin/admin"
```

7. Exit the container.

## Step 2: Set up the Kerberos Client Container

1. Create a Docker container for the Kerberos client:
```bash
docker run -d --name kerberos-client --hostname client.example.com --link kerberos-server:kdc.example.com ubuntu:24.04
```

2. Access the container:
```bash
docker exec -it kerberos-client /bin/bash
```

3. Update and install necessary packages:
```bash
apt update
apt install -y krb5-user
```

4. Configure the client:
```bash
nano /etc/krb5.conf
```
Add the same realm configuration as in the server.

5. Test the connection:
```bash
kinit admin/admin
```
Enter the password you set for the admin principal.

6. Verify the ticket:
```bash
klist
```

7. Exit the container.

## Step 3: Set up a Service Container with Kerberos Authentication

For this example, we'll set up an SSH server that uses Kerberos authentication.

1. Create a Docker container for the SSH server:
```bash
docker run -d --name ssh-server --hostname ssh.example.com --link kerberos-server:kdc.example.com ubuntu:24.04
```

2. Access the container:
```bash
docker exec -it ssh-server /bin/bash
```

3. Update and install necessary packages:
```bash
apt update
apt install -y openssh-server krb5-user libpam-krb5
```

4. Configure Kerberos:
```bash
nano /etc/krb5.conf
```
Add the same realm configuration as before.

5. Configure SSH to use Kerberos:
```bash
nano /etc/ssh/sshd_config
```
Add or modify these lines:
```
KerberosAuthentication yes
GSSAPIAuthentication yes
```

6. Restart the SSH service:
```bash
service ssh restart
```

7. Create a test user:
```bash
adduser testuser
```

8. Exit the container.

## Step 4: Test Kerberos Authentication

1. On the Kerberos server, create a principal for the test user:
```bash
docker exec -it kerberos-server kadmin.local -q "addprinc testuser"
```

2. On the client container, authenticate as the test user:
```bash
docker exec -it kerberos-client kinit testuser
```

3. Try to SSH into the SSH server:
```bash
docker exec -it kerberos-client ssh testuser@ssh-server
```

If everything is set up correctly, you should be able to log in without a password, using Kerberos authentication.

This setup demonstrates a basic Kerberos infrastructure within Docker containers, including a server, client, and an authenticated service[1][2][4].

Citations:
[1] https://www.howtoforge.com/how-to-setup-kerberos-server-and-client-on-ubuntu-1804-lts/
[2] https://www.confluent.io/blog/containerized-testing-with-kerberos-and-ssh/
[3] https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/using_containerized_identity_management_services/creating-and-using-a-centralized-kerberos-credential-cache
[4] https://www.atlantic.net/dedicated-server-hosting/how-to-setup-kerberos-server-and-client-on-ubuntu/
[5] https://containerssh.io/v0.4/reference/upcoming/auth-kerberos/
[6] https://www.redhat.com/en/blog/kerberos-sidecar-container
[7] https://ubuntu.com/server/docs/how-to-install-a-kerberos-server
[8] https://doc.kerberos.io/opensource/installation/
[9] https://linuxconfig.org/how-to-install-kerberos-kdc-server-and-client-on-ubuntu-18-04
[10] https://docs.hitachivantara.com/r/en-us/pentaho-data-integration-and-analytics/9.5.x/mk-95pdia001/pentaho-installation/docker-container-deployment-of-pentaho/using-your-docker-containers-with-clusters/use-the-docker-command-tool-with-a-kerberos-secured-cluster
[11] https://stackoverflow.com/questions/62871161/kerberos-client-inside-docker-container
[12] https://github.com/kerberos-io/kerberos-docker