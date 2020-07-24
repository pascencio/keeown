#!/bin/bash
nginxSocket="/tmp/nginx.socket"
command=$@
socketPid=-1
log(){
    now=$(date +"%Y-%d-%m %H:%M:%S")
    echo "[INFO]:[${now}] - ${1}"
}
socketChmod(){
    log " #### Waiting $nginxSocket file exist"
    while [ ! -S $nginxSocket ];
    do
        sleep 1
    done
    chmod 777 $nginxSocket
    log " #### Permissions of $nginxSocket file changed"
}
socketStart(){
    exec $command &
    socketPid=$!
}
socketStop(){
    kill -2 $socketPid
    rm -f $nginxSocket
    socketPid=-1
}
start(){
    log " #### Executing command: $@"
    socketChmod &
    exec $command
}
startAndWatch(){
    socketStart
    socketChmod
    log " #### Waiting for new changes"
    while inotifywait -r -e modify /go/src/api ; do
        log " #### Changes detected!"
        socketStop
        socketStart
        socketChmod
        log " #### Waiting for new changes"
    done
}
if [ -S $nginxSocket ];
then
    rm -f $nginxSocket
fi
if [ ! -d /go/src/api ];
then
    start
else
    startAndWatch
fi