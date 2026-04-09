#!/bin/bash

DEBUG=0
DATADIR="/mnt/ramfs/1000/rpiboiler"
DATAFILE="boiler-tm_`date '+%G%m%d'`.csv"
TARGETDIR="data/rpiboiler"

OWREAD="owread"

function read_air_data {
  curl -s http://192.168.77.108/values  | perl -e '
      while ( my $line = <> ) {
        if ( $line =~ /^.*<tr><td>BME280<\/td><td>temperature<\/td><td class=.r.>(-*[.\d]*)&nbsp;°C<\/td><\/tr>.*$/ ) {
          #print("DBG Line:", $line, "\n", "Teplota: ", $1, "\n");
          print($1);
        }
      }
  '
}

function eval_command {
  cmd="$1"
  timeout="$2"

  ( 
    eval "$cmd" &
      child=$!
      trap -- "" SIGTERM 
      (       
        sleep $timeout
        kill $child 2> /dev/null 
      ) &     
      wait $child
  )
}

# 9C873E1B1901:TO_vstup:green
# 4618C1070000:TUV_vstup:red
# F6775F070000:TUV_teplota:orange
# 41DA211C1901:TO_zpet:yellow

OW_DATE=`date '+%d.%m.%Y'`
OW_TIME=`date '+%H:%M:%S'`
TO_INP=`${OWREAD} /28.9C873E1B1901/temperature`
TO_OUT=`${OWREAD} /28.41DA211C1901/temperature`
TUV_TEMP=`${OWREAD} /28.F6775F070000/temperature`
TUV_INP=`${OWREAD} /28.4618C1070000/temperature`
AIR_TEMP=`eval_command read_air_data 15`

  if [ ! -d ${DATADIR} ]; then
    mkdir -p ${DATADIR}
    echo "boiler-tm.sh: INFO: Create directory ${DATADIR}."
    #exit 0
  fi

if [ ${DEBUG} -eq 0 ]; then
  echo "${OW_DATE} ${OW_TIME} INFO: boiler-tm.sh: Run"
fi

if [ ! -r "${DATADIR}/${DATAFILE}" ]; then
  if [ ! -d ${DATADIR} ]; then
    echo "boiler-tm.sh: INFO: Create directory ${DATADIR}."
    mkdir -p ${DATADIR}
  fi
  # Check if exist on remote
  /usr/local/bin/rclone lsf gdrive:${TARGETDIR} | grep '^'"${DATAFILE}"'$'
  RC=$?
  if [ $RC -eq 0 ]; then
    echo "boiler-tm.sh: INFO: Copy file ${DATAFILE} from gdrive:${TARGETDIR}."
    /usr/local/bin/rclone copy gdrive:${TARGETDIR}/${DATAFILE} ${DATADIR}
    ls -l ${DATADIR}/${DATAFILE}
  fi
fi


if [ ! -r ${DATADIR}/${DATAFILE} ]; then
  echo "Date,Time,TUV_teplota,TUV_vstup,TO_vstup,TO_zpet,Venkovni" > ${DATADIR}/${DATAFILE}
fi

echo "${OW_DATE},${OW_TIME},${TUV_TEMP},${TUV_INP},${TO_INP},${TO_OUT},${AIR_TEMP}" >> ${DATADIR}/${DATAFILE}

