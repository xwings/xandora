#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Checking and initializing

getinfo
getxidremote
cd $BASEDIR

## Upload

GENFILES="$(ls $BASEDIR/newfiles)"

cd $BASEDIR/newfiles

for a in $GENFILES; do

if [ -f $a ]; then
ncftp -u generated -p generated77889900 a.xandora.net <<END_SCRIPT
		bin
		mput $a
		bye
END_SCRIPT
rm $a
fi

done
