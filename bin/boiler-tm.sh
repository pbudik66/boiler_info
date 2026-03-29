#!/bin/bash

DEBUG=0
DATADIR="/mnt/ramfs/1000/rpiboiler"
DATAFILE="boiler-tm_`date '+%G%m%d'`.csv"
TARGETDIR="data/rpiboiler"

# 9C873E1B1901:TO_vstup:green
# 4618C1070000:TUV_vstup:red
# F6775F070000:TUV_teplota:orange
# 41DA211C1901:TO_zpet:yellow

OW_DATE=`date '+%d.%m.%Y'`
OW_TIME=`date '+%H:%M:%S'`
TO_INP=`owread /28.9C873E1B1901/temperature`
TO_OUT=`owread /28.41DA211C1901/temperature`
TUV_TMP=`owread /28.F6775F070000/temperature`
TUV_INP=`owread /28.4618C1070000/temperature`

if [ ${DEBUG} -eq 0 ]; then
  echo "${OW_DATE} ${OW_TIME} INFO: boiler-tm.sh: Run"
fi

if [ ! -r "${DATADIR}/${DATAFILE}" ]; then
  if [ ! -d ${DATADIR} ]; then
    echo "boiler-tm.sh: INFO: Create directory ${DATADIR}."
    mkdir -p ${DATADIR}
  fi
  # Check if exist on remote
  /usr/bin/rclone lsf gdrive:${TARGETDIR} | grep '^'"${DATAFILE}"'$'
  RC=$?
  if [ $RC -eq 0 ]; then
    echo "boiler-tm.sh: INFO: Copy file ${DATAFILE} from gdrive:${TARGETDIR}."
    /usr/bin/rclone copy gdrive:${TARGETDIR}/${DATAFILE} ${DATADIR}
    ls -l ${DATADIR}/${DATAFILE}
  fi
fi


if [ ! -r ${DATADIR}/${DATAFILE} ]; then
  echo "Date,Time,TUV_teplota,TUV_vstup,TO_vstup,TO_zpet" > ${DATADIR}/${DATAFILE}
fi

echo "$OW_DATE,$OW_TIME,$TUV_TMP,$TUV_INP,$TO_INP,$TO_OUT" >> ${DATADIR}/${DATAFILE}

