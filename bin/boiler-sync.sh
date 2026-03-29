#!/bin/bash

WORKDIR="/run/user/1000/rpiboiler"
TARGETDIR="/data/rpiboiler"

/usr/bin/rclone sync ${WORKDIR} gdrive:${TARGETDIR}
