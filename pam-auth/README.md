

# docker buildx build -t pamclient:v1 .
# docker stop pamclient 
# docker rm pamclient
# docker attach pamclient
# docker run -dit --net=krb5 --name pamclient --hostname pamclient.jai.net -p 389:389/tcp -p 389:389/udp -p 666:666/tcp -p 666:666/udp -p 636:636/tcp -p 636:636/udp pamclient:v1 /bin/bash
# docker run -dit --net=krb5 --name pamclient --hostname pamclient.jai.net -p 389:389/tcp -p 666:666/tcp -p 636:636/tcp pamclient:v1 /bin/bash
# docker exec pamclient /setup-service.sh

## docker rm -f pamclient && docker run -dit --net=krb5 --name pamclient --hostname pamclient.jai.net pamclient:v1 /bin/bash && docker attach pamclient