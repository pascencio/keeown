#/bin/bash
app_initialized="/tmp/app-initialized"
echo "Waiting for ${app_initialized} file exist"
while [ ! -f ${app_initialized} ];
do
    sleep 1
done
echo "${app_initialized} file ready!"
