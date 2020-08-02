#!/bin/bash
nginxSocket="/tmp/nginx.socket"
app="/go/src/keeown-api"
command=$@
socketPid=-1
maxRetry=10
log(){
    now=$(date +"%Y-%d-%m %H:%M:%S")
    echo "[INFO]:[${now}] - ${1}"
}
socketChmod(){
    log " #### Waiting $nginxSocket file exist"
    retry=0
    while [ ! -S $nginxSocket ] && [ $retry -lt $maxRetry ];
    do
        sleep 1
        ((retry++))
    done
    if [ -S $nginxSocket ];
    then
        chmod 777 $nginxSocket
        log " #### Permissions of $nginxSocket file changed"
    else
        log "  #### Wait retries exceeded"
    fi
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
    while inotifywait -r -e modify $app ; do
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
if [ ! -d $app ];
then
    start
else
    startAndWatch
fi