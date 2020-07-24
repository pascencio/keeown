FROM node

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER node

WORKDIR /home/node/ui

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]