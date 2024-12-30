### Create custom network for SMALL-ENTERPRISE

```bash
docker network create --driver bridge --subnet=172.28.0.0/16 --gateway=172.28.0.1 --label name=jai_net jai_net
```


### Create custom network for SMALL-ENTERPRISE

```bash
docker network rm jai_net
```
