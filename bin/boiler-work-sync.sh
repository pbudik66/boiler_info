#!/bin/bash

WORKDIR="${HOME}/work"
TARGETDIR="/work"

for DR in 1wire rpiboiler
do
  echo "Synchronizuji ${WORKDIR}/${DR}"
  /usr/bin/rclone sync ${WORKDIR}/${DR} gdrive:${TARGETDIR}/${DR}
done
