COMMAND_PATH=$0
INSTALL_DIRECTORY=${1:-/usr/local/bin}
[ $# = 0 ] && mkdir -p /usr/local/bin

cd `dirname $COMMAND_PATH`
cp -p rec_radiko.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radiko.sh
cp -p rec_radiru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radiru.sh
cp -p rec_radikoru.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/rec_radikoru.sh
cp -p find_radiko.sh $INSTALL_DIRECTORY && echo install $INSTALL_DIRECTORY/find_radiko.sh

cd $INSTALL_DIRECTORY
chmod +x rec_radiko.sh rec_radiru.sh rec_radikoru.sh find_radiko.sh
