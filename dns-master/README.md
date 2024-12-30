

```bash
docker compose up --remove-orphans --wait
docker compose up --remove-orphans --wait --build
```

```bash
docker compose down --remove-orphans
```

```bash
docker attach dnsmaster
```

```bash
docker compose up --remove-orphans --wait --build && docker exec dnsmaster /setup-service.sh
docker compose up --remove-orphans --wait --build && docker attach dnsmaster
```

```bash
# openssl genrsa -aes256 -passout file:/root/ca/private/passphrase.txt -out /root/ca/private/cakey.pem 4096
openssl genrsa -aes256 -out dnsmaster.pem 2048
openssl req -new -config openssl_new_cacert.cnf -days 3650 -key dnsmaster.pem -out dnsmaster.csr
```

```bash
```



docker network create --driver bridge --subnet=172.28.0.0/16 --gateway=172.28.0.1 --label name=jai_net jai_net

docker network create -d bridge my-bridge-network


docker network create --subnet=10.5.0.0/16 custom_net

docker network create \
  --driver=bridge \
  --subnet=172.28.0.0/16 \
  --ip-range=172.28.5.0/24 \
  --gateway=172.28.5.254 \
  br0

  docker network create -d overlay \
  --subnet=192.168.10.0/25 \
  --subnet=192.168.20.0/25 \
  --gateway=192.168.10.100 \
  --gateway=192.168.20.100 \
  --aux-address="my-router=192.168.10.5" --aux-address="my-switch=192.168.10.6" \
  --aux-address="my-printer=192.168.20.5" --aux-address="my-nas=192.168.20.6" \
  my-multihost-network



Links:
https://wiki.archlinux.org/title/Transport_Layer_Security
https://www.youtube.com/watch?v=oCl0gzLPPMI&t=535s

https://wiki.archlinux.org/title/Network_Time_Protocol_daemon
https://wiki.archlinux.org/title/Easy-RSA

https://archlinux.org/news/ca-certificates-update/
https://unix.stackexchange.com/questions/373492/installing-certificates-on-arch
https://wiki.archlinux.org/title/User:Grawity/Adding_a_trusted_CA_certificate