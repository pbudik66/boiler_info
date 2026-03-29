#!/bin/bash

WORKDIR="/mnt/ramfs/1000/rpiboiler"
CSV="${WORKDIR}/boiler-tm_`date '+%G%m%d'`.csv"

TARGETDIR="/data/rpiboiler"

/usr/bin/rclone sync ${CSV} gdrive:${TARGETDIR}
