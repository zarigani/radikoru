INSTALL_DIRECTORY=${1:-/usr/local/bin}
[ $# = 0 ] && mkdir -p /usr/local/bin

cd `dirname $0`
cp -p rec_radiko.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radiko.sh
cp -p rec_radiru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radiru.sh
cp -p rec_radikoru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radikoru.sh
cp -p find_radikoru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radikoru.sh

cd $INSTALL_DIRECTORY
chmod +x rec_radiko.sh rec_radiru.sh rec_radikoru.sh find_radikoru.sh
