#!/bin/bash

# Tested to Ubuntu 16.04.3
# Prereqs: Qt5.x and git
# Prereqs can be installed using
# sudo apt-get install qtbase5-dev
# sudo apt-get install qt5-default
# sudo apt-get install git-core
# sudo apt-get install git

if [ ! -d gnss_sdr_gui ];
then
echo "Clonning..."
git clone https://github.com/UHaider/gnss_sdr_gui.git
fi

if [ ! -d gnss_sdr_gui/src ];
then
echo "Could not find gnss_sdr_gui/src after GIT checkout. Exiting"
exit
fi

CHECK=""
DESTDIR=""
GUI_INI_FILES=""

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -G|--GUI_INI_FILES)
    GUI_INI_FILES="$2"
    shift # past argument
    ;;
    -D|--DESTDIR)
    DESTDIR="$2"
    shift # past argument
    ;;
    --default)
    ;;
    *)
    ;;
esac
shift # past argument or value
done

echo EXECUTABLE DIRECTORY = "${DESTDIR}"
echo REFERENCE INI FILE LOCATION = "${GUI_INI_FILES}"

COPIED=0
if [ "$GUI_INI_FILES" != "$CHECK" ];
then
if [ -d gnss_sdr_gui/gui_ini_files ];
then
echo "Copying reference files  in " "${GUI_INI_FILES}"
echo -n "Proceed?"
read ans
case $ans in
	y|Y|YES|yes|Yes)
	cp -R gnss_sdr_gui/gui_ini_files "${GUI_INI_FILES}"
	COPIED=$?
	echo "copied"
esac

fi
fi

cd gnss_sdr_gui/src
qmake gnss_sdr_gui.pro DESTDIR="${DESTDIR}" GUI_FILES_LOCATION="${GUI_INI_FILES}"
make clean
make
echo
echo
RED='\033[0;31m'
GREEN='\033[0;32m'
if [ "$DESTDIR" != "$CHECK" ];
then
echo -e "${GREEN}For executable please check " "${DESTDIR}"
else
echo -e "${RED}For executable please check " $(pwd)
fi

if [ $COPIED -ne 0 ];
then
echo -e "${GREEN}For reference files please check " "${GUI_INI_FILES}"
else
echo -e "${RED}Please manually place reference files in " "${HOME}"
fi






