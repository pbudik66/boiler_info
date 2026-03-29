#!/bin/bash

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

echo "$OW_DATE,$OW_TIME,$TUV_TMP,$TUV_INP,$TO_INP,$TO_OUT"
