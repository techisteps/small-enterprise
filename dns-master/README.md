

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


[Youtube: How To Install And Configure DNS Server In Linux](https://www.youtube.com/watch?v=VjZD3kkBzRE)