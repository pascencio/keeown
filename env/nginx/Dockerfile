FROM nginx

COPY wait-for-unix-socket.sh /docker-entrypoint.d/
COPY nginx.conf /etc/nginx/conf.d/heroku.conf

RUN chmod +x /docker-entrypoint.d/wait-for-unix-socket.sh