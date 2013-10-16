#!/bin/bash

cd `dirname $0`

# 使い方
show_usage() {
  echo "Usage: $COMMAND [-al] [-o output_path] [-t recording_seconds] station_ID"
  echo '       -a  Output area info(ex. 'JP13,東京都,tokyo Japan'). No recording.'
  echo '       -l  Output station list. No recording.'
  echo '       -o  Default output_path = $HOME/Downloads/${station_name}_`date +%Y%m%d-%H%M`.flv'
  echo '             a/b/c/ = $HOME/Downloads/a/b/c/J-WAVE_20130123-1700.flv'
  echo '             a/b/c  = $HOME/Downloads/a/b/c.flv'
  echo '            /a/b/c/ = /a/b/c/J-WAVE_20130123-1700.flv'
  echo '            /a/b/c  = /a/b/c.flv'
  echo '           ./a/b/c/ = ./a/b/c/J-WAVE_20130123-1700.flv'
  echo '           ./a/b/c  = ./a/b/c.flv'
  echo '       -t  Default recording_seconds = 30'
  echo '           60 = 1 minute, 3600 = 1 hour, 0 = go on recording until stopped(control-C)'
}

while getopts laho:t: OPTION
do
  case $OPTION in
    l ) OPTION_l="TRUE" ;;
    h ) show_usage ; exit 1 ;;
  esac
done

if [ $# = 0 ]; then
  show_usage ; exit 1
fi

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
