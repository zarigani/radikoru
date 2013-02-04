INSTALL_DIRECTORY=${1:-/usr/local/bin}
[ $# = 0 ] && mkdir -p /usr/local/bin

cd `dirname $0`
mv rec_radiko.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radiko.sh
mv rec_radiru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radiru.sh
mv rec_radikoru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radikoru.sh

cd $INSTALL_DIRECTORY
chmod +x rec_radiko.sh rec_radiru.sh rec_radikoru.sh
