#!/bin/bash

IND_FILE="index.html"

function read_air_data {
  curl -s http://192.168.77.108/values  | perl -e '
  while ( my $line = <> ) {
    if ( $line =~ /^.*<tr><td>BME280<\/td><td>temperature<\/td><td class=.*>([.\d]*)&nbsp;°C<\/td><\/tr>.*$/ ) {
      #print("DBG Line:", $line, "\n", "Teplota: ", $1, "\n");
      print($1);
    }
  }
'
}

function write_html {

echo '<h1>RPI Boiler</h1>' > ${IND_FILE}
echo '<p><strong>Date:</strong>       '"${OW_DATE}"'</p>' >> ${IND_FILE}
echo '<p><strong>Time:</strong>       '"${OW_TIME}"'</p>' >> ${IND_FILE}
echo '<table><thead><tr>' >> ${IND_FILE}
echo '<th align="left">Venkovni vzduch_______________</th><th align="right">Teplota [C]</th>' >> ${IND_FILE}
echo '</tr></thead>' >> ${IND_FILE}
echo '<tbody><tr>' >> ${IND_FILE}
echo '<td align="left">Teplota</td><td align="right">'"${AIR_TEMP}"'</td>' >> ${IND_FILE}
echo '</tr></tbody></table>' >> ${IND_FILE}
echo '<table><thead><tr>' >> ${IND_FILE}
echo '<th align="left">Tepla uzitkova voda____________</th><th align="right">Teplota [C]</th>' >> ${IND_FILE}
echo '</tr></thead>' >> ${IND_FILE}
echo '<tbody><tr>' >> ${IND_FILE}
echo '<td align="left">TUV Teplota:</td><td align="right">'"${TUV_TEMP}"'</td>' >> ${IND_FILE}
echo '</tr>' >> ${IND_FILE}
echo '<tr>' >> ${IND_FILE}
echo '<td align="left">TUV Vstup:</td><td align="right">'"${TUV_INP}"'</td>' >> ${IND_FILE}
echo '</tr></tbody></table>' >> ${IND_FILE}
echo '<table><thead><tr>' >> ${IND_FILE}
echo '<th align="left">Topny okruh__________________</th><th align="right">Teplota [C]</th>' >> ${IND_FILE}
echo '</tr></thead>' >> ${IND_FILE}
echo '<tbody><tr>' >> ${IND_FILE}
echo '<td align="left">TO Vstup</td><td align="right">'"${TO_INP}"'</td>' >> ${IND_FILE}
echo '</tr>' >> ${IND_FILE}
echo '<tr>' >> ${IND_FILE}
echo '<td align="left">TO Zpet</td><td align="right">'"${TO_OUT}"'</td>' >> ${IND_FILE}
echo '</tr></tbody></table>' >> ${IND_FILE}
}

# 9C873E1B1901:TO_vstup:green
# 4618C1070000:TUV_vstup:red
# F6775F070000:TUV_teplota:orange
# 41DA211C1901:TO_zpet:yellow

OW_DATE=`date '+%d.%m.%Y'`
OW_TIME=`date '+%H:%M:%S'`
TO_INP=`owread /28.9C873E1B1901/temperature`
TO_OUT=`owread /28.41DA211C1901/temperature`
TUV_TEMP=`owread /28.F6775F070000/temperature`
TUV_INP=`owread /28.4618C1070000/temperature`
AIR_TEMP=`read_air_data`

echo "$OW_DATE,$OW_TIME,$TUV_TEMP,$TUV_INP,$TO_INP,$TO_OUT,$AIR_TEMP"

write_html

