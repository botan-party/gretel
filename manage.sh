#!/bin/bash
set -e

SUB_COMMAND=$1
SERVER_PATH="/home/$(whoami)/opt/spigot"

start() {
  local SPIGOT_ARGS NEED_UPGRADE_MARKER_FILE

  SPIGOT_ARGS="--nogui"

  # if needs world upgrade, specify --forceUpgrade
  NEED_UPGRADE_MARKER_FILE="${SERVER_PATH}/tmp/need-upgrade"
  if [[ -e ${NEED_UPGRADE_MARKER_FILE} ]]; then
      SPIGOT_ARGS="${SPIGOT_ARGS} --forceUpgrade"
      rm ${NEED_UPGRADE_MARKER_FILE}
  fi

  screen -ADmS spigot java -Xms2048M -Xmx2048M -jar $SERVER_PATH/spigot-server.jar $SPIGOT_ARGS
}

stop() {
  screen -S spigot -X stuff "say This server will be shutdown in 10s\n"
  sleep 10
  screen -S spigot -X stuff "save-all\n"
  screen -S spigot -X stuff "stop\n"
}

case $SUB_COMMAND in
  'start')
    start
    ;;
  'stop')
    stop
    ;;
esac
