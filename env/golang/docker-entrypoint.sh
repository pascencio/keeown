#!/bin/bash
nginx_socket="/tmp/nginx.socket"
log(){
    now=$(date +"%Y-%d-%m %H:%M:%S")
    echo "[INFO]:[${now}] - ${1}"
}
change_socket_permissions(){
    echo "Waiting ${nginx_socket} file exist"
    while [ ! -S ${nginx_socket} ];
    do
        sleep 1
    done
    chmod 777 ${nginx_socket}
    echo "Permissions of ${nginx_socket} file changed"
}
start_app(){
    exec $@
}
change_socket_permissions &
if [ ! -d /go/src/api ];
then
    log "Executing command: $@"
    
    exit 0
fi
start_app &
log "#### Waiting for new changes"
while inotifywait -r -e modify /go/src/api ; do
    log "#### Changes detected!"
    change_socket_permissions &
    start_app &
    log "#### Waiting for new changes"
done
