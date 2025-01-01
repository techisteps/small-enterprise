To install Docker on Ubuntu 24.04, follow these steps:

## Update and Prepare the System

1. Update the package index:
```bash
sudo apt update
```

2. Install necessary dependencies:
```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
```

## Add Docker Repository

1. Add Docker's official GPG key:
```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

2. Add the Docker repository to APT sources:
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

3. Update the package index again:
```bash
sudo apt update
```

## Install Docker

Install the Docker packages:
```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Post-Installation Steps

1. Add your user to the docker group to run Docker commands without sudo:
```bash
sudo usermod -aG docker ${USER}
```

2. Log out and log back in for the group changes to take effect.

## Verify Installation

Test the installation by running the hello-world container:
```bash
docker run hello-world
```

If successful, you'll see a welcome message indicating that Docker is properly installed and functioning[1][2][3][4].

Citations:
[1] https://www.youtube.com/watch?v=psxQIwgTFdc
[2] https://linuxconfig.org/quick-docker-installation-on-ubuntu-24-04
[3] https://www.cherryservers.com/blog/install-docker-ubuntu
[4] https://www.jpaul.me/2024/07/how-to-install-and-use-docker-on-ubuntu-24-04/
[5] https://www.youtube.com/watch?v=J4dZ2jcpiP0