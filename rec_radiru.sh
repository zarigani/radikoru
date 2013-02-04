#!/bin/sh
# Original: http://qiita.com/items/549b42c8b361807d96a2
# Original: https://gist.github.com/1185755 saiten / radiru.txt

# Install: rtmpdump2.4 http://trick77.com/downloads/ 

PATH=$PATH:/usr/local/bin

# 使い方
show_usage() {
  echo "Usage: $COMMAND [-o output_path] [-t recording_seconds] NHK-R1 | NHK-R2 | NHK-FM"
  echo '       -o  Default output_path = $HOME/Downloads/${station_name}_`date +%Y%m%d-%H%M`.flv'
  echo '             a/b/c/ = $HOME/Downloads/a/b/c/NHK-FM_20130123-1700.flv'
  echo '             a/b/c  = $HOME/Downloads/a/b/c.flv'
  echo '            /a/b/c/ = /a/b/c/NHK-FM_20130123-1700.flv'
  echo '            /a/b/c  = /a/b/c.flv'
  echo '           ./a/b/c/ = ./a/b/c/NHK-FM_20130123-1700.flv'
  echo '           ./a/b/c  = ./a/b/c.flv'
  echo '       -t  Default recording_seconds = 30'
  echo '           60 = 1 minute, 3600 = 1 hour, 0 = go on recording until stopped(control-C)'
}

# 引数解析
COMMAND=`basename $0`
while getopts ho:t: OPTION
do
  case $OPTION in
    o ) OPTION_o="TRUE" ; VALUE_o="$OPTARG" ;;
    t ) OPTION_t="TRUE" ; VALUE_t="$OPTARG" ;;
    * ) show_usage ; exit 1 ;;
  esac
done

shift $(($OPTIND - 1)) #残りの非オプションな引数のみが、$@に設定される

if [ $# = 0 ]; then
  show_usage ; exit 1
fi

# オプション処理
if [ "$OPTION_o" = "TRUE" ]; then
  if echo $VALUE_o|grep -q -v -e '^./\|^/'; then
    mkdir -p $HOME/Downloads ; cd $HOME/Downloads
  fi
  fname_ext="${VALUE_o##*/}"
  fname="${fname_ext%.*}"
  fext="${fname_ext#$fname}"
  wdir="${VALUE_o%/*}"; [ "$fname_ext" = "$wdir" ] && wdir=""
fi

if [ "$OPTION_t" = "TRUE" ]; then
  rectime=$VALUE_t
fi

mkdir -p ${wdir:=$HOME/Downloads} ; cd $wdir ; wdir=`pwd`
output="${wdir}/${fname:=$1_`date +%Y%m%d-%H%M`}${fext:=.flv}"

case $1 in
  NHK-R1) PLAYPATH="NetRadio_R1_flash@63346" ;; # らじる★らじる ラジオ第1ストリーム
  NHK-R2) PLAYPATH="NetRadio_R2_flash@63342" ;; # らじる★らじる ラジオ第2ストリーム
  NHK-FM) PLAYPATH="NetRadio_FM_flash@63343" ;; # らじる★らじる NHK-FMストリーム
esac

echo "==== recording ===="
echo "save as '$output'"
rtmpdump --rtmp "rtmpe://netradio-${1##*-}-flash.nhk.jp" \
         --playpath "$PLAYPATH" \
         --app "live" \
         -W http://www3.nhk.or.jp/netradio/files/swf/rtmpe.swf \
         --live \
         --stop "${rectime:=30}" \
         -o "${output}"

ffmpeg -v quiet -y -i "${output}" -acodec copy "${output%.*}.m4a"
rm -f "${output}"
