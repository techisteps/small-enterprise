

# docker buildx build -t ldapclient:v1 .
# docker stop ldapclient 
# docker rm ldapclient
# docker attach ldapclient
# docker run -dit --net=krb5 --name ldapclient --hostname ldapclient.jai.net -p 389:389/tcp -p 389:389/udp -p 666:666/tcp -p 666:666/udp -p 636:636/tcp -p 636:636/udp ldapclient:v1 /bin/bash
# docker run -dit --net=krb5 --name ldapclient --hostname ldapclient.jai.net -p 389:389/tcp -p 666:666/tcp -p 636:636/tcp ldapclient:v1 /bin/bash
# docker exec ldapclient /setup-service.sh

## docker rm -f ldapclient && docker run -dit --net=krb5 --name ldapclient --hostname ldapclient.jai.net ldapclient:v1 /bin/bash && docker attach ldapclient