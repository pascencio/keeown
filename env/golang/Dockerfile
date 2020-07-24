FROM golang

COPY docker-entrypoint.sh /usr/local/bin/

RUN apt update -y && \
apt install -y inotify-tools && \
chmod +x /usr/local/bin/docker-entrypoint.sh && \
mkdir -p /go/src/api

WORKDIR /go/src/api

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]