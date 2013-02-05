#!/bin/bash

cd `dirname $0`

while getopts laho:t: OPTION
do
  case $OPTION in
    l ) OPTION_l="TRUE" ;;
  esac
done

if [ "$OPTION_l" = "TRUE" ]; then
  areaid=`/usr/local/bin/rec_radiko.sh -a|tail -1|cut -d, -f1`

  station_names=`echo ---- NAME ----,NHK-R1,NHK-R2,NHK-FM,`
  station_names+=`curl -s http://radiko.jp/v2/station/list/$areaid.xml|xpath //name 2>/dev/null|sed -e 's/<name>//g' -e 's/<\\/name>/,/g'`

  station_ids=`echo ---- ID ----,NHK-R1,NHK-R2,NHK-FM,`
  station_ids+=`curl -s http://radiko.jp/v2/station/list/$areaid.xml|xpath //id 2>/dev/null|sed -e 's/<id>//g' -e 's/<\/id>/,/g'`

  paste <(echo $station_ids|tr ',' '\n') <(echo $station_names|tr ',' '\n')|expand -t 16
  exit 0
fi

echo $@|grep 'NHK-\(R1\|R2\|FM\)$' && ./rec_radiru.sh $@
echo $@|grep 'NHK-\(R1\|R2\|FM\)$' || ./rec_radiko.sh $@
