#!/bin/sh
set -e

PID=0
start() {
    if [ ! -e ${OPT_DIR}/version.txt ]; then
        echo ${VERSION} > ${OPT_DIR}/version.txt
        echo "eula=${EULA}" > ${OPT_DIR}/eula.txt
    fi
    local EXISTING_VERSION=$(cat ${OPT_DIR}/version.txt)

    local spigot_args="--nogui"
    if [ ${VERSION} != ${EXISTING_VERSION} ]; then
        spigot_args="${spigot_args} --forceUpgrade"
    fi

    cp ${TMP_DIR}/spigot-server.jar ${OPT_DIR}/spigot-server.jar
    (screen -DmS spigot java -Xms${MIN_MEMORY} -Xmx${MAX_MEMORY} -jar ${OPT_DIR}/spigot-server.jar ${spigot_args}) &
    sleep 1
    PID=$(screen -ls | grep spigot | cut -f 1 -d '.' | tr -d '\t')
}

stop() {
    screen -S spigot -X stuff "say This server will be shutdown in 10s\n"
    sleep 10
    screen -S spigot -X stuff "save-all\n"
    screen -S spigot -X stuff "stop\n"
}
trap 'stop' SIGINT SIGTERM

start
exec "$@"
wait $PID
