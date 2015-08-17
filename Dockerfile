FROM alpine

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update \
 && apk add    \
 bash          \
 easy-rsa

COPY ./skel /

RUN chmod +x ./init.sh

CMD ["./init.sh"]
