#!/bin/sh
set -e

start() {
    local world_version='0'
    if [ -e ${OPT_DIR}/version.txt ]; then
        world_version=$(cat ${OPT_DIR}/version.txt)
    else
        echo ${VERSION} > ${OPT_DIR}/version.txt
        echo "eula=${EULA}" > ${OPT_DIR}/eula.txt
    fi

    local spigot_args="--nogui"
    if [ ${VERSION} != ${world_version} ]; then
        spigot_args="${spigot_args} --forceUpgrade"
    fi
    screen -ADmS spigot java -Xms2048M -Xmx2048M -jar ${OPT_DIR}/spigot-server.jar ${spigot_args}
}

stop() {
    screen -S spigot -X stuff "say This server will be shutdown in 10s\n"
    sleep 10
    screen -S spigot -X stuff "save-all\n"
    screen -S spigot -X stuff "stop\n"
    exit 0
}
trap 'stop' TERM

start
exec "$@"

while sleep 1000; do :; done
