#!/bin/bash

timer_format() {
  IFS=' '
  set `echo $@|expand`
  m=`echo $1|cut -c5-6`
  d=`echo $1|cut -c7-8`
  hhmm=`echo $1|cut -c9-12`
  echo $m/$d $hhmm /usr/local/bin/rec_radikoru.sh -o radikoru/ -t $2 $3
}

show_keyword_line() {
  IFS=' '
  set `echo $@|expand`
  echo "--------------------" $@
  xpath $PROGRAM_XML //prog[@ft="$1"] 2>/dev/null|grep $KEYWORD
  echo "===================="
}

preset_timer() {
  for line in "$@"
  do
    if `echo $line|grep -q '\w\{2,\}'`; then
      show_keyword_line $line $ID_NAME
      echo timer -${VALUE_de:=e} `timer_format $line $ID_NAME`
      echo
      if [ "$OPTION_d" = "TRUE" -o "$OPTION_e" = "TRUE" ]; then
        ./timer -$VALUE_de `timer_format $line $ID_NAME`
      fi
    fi
  done
}

show_usage() {
  echo "Usage: $COMMAND [-de] SEARCH_WORD [AREA_ID]"
}




cd `dirname $0`
COMMAND=`basename $0`

# 引数解析
while getopts de OPTION
do
  case $OPTION in
    d ) OPTION_d="TRUE" ; VALUE_de="d" ;;
    e ) OPTION_e="TRUE" ; VALUE_de="e" ;;
    * ) show_usage ; exit 1 ;;
  esac
done

shift $(($OPTIND - 1)) #残りの非オプションな引数のみが、$@に設定される

if [ $# = 0 ]; then
  show_usage ; exit 1
fi

# オプション処理
KEYWORD="$1"
AREA_ID=${2:-`./rec_radiko.sh -a|tail -1|cut -d, -f1`}
STATION_IDs=`curl -s http://radiko.jp/v2/station/list/${AREA_ID}.xml|xpath //id 2>/dev/null|sed -e 's/<id>//g' -e 's/<\/id>/,/g'|tr ',' '\n'`
STATION_NAMEs=`curl -s http://radiko.jp/v2/station/list/${AREA_ID}.xml|xpath //name 2>/dev/null|sed -e 's/<name>//g' -e 's/<\/name>/,/g'|tr ',' '\n'`
IDs_NAMEs=`paste <(echo "$STATION_IDs") <(echo "$STATION_NAMEs")|expand`
PROGRAM_XML=`mktemp -t com.bebekoubou.radiko_program`

echo AreaID=$AREA_ID
echo

_IFS="$IFS"
IFS=$'\n'
for ID_NAME in $IDs_NAMEs
do
  IFS="$_IFS"
  set $ID_NAME
  curl -s http://radiko.jp/v2/api/program/station/weekly?station_id=$1 > $PROGRAM_XML
  
  IFS=$'\n'
  prog=`grep -B16 "$KEYWORD" $PROGRAM_XML|grep '<prog ft='`
  prog_ft=`echo "$prog"|sed 's/^.*ft="\([0-9]*\)".*$/\1/'`
  prog_dur=`echo "$prog"|sed 's/^.*dur="\([0-9]*\)".*$/\1/'`
  ft_dur=`paste <(echo "$prog_ft") <(echo "$prog_dur")|expand`
  preset_timer $ft_dur
done
IFS="$_IFS"

rm -f $PROGRAM_XML