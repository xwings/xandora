#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Checking and initializing

getinfo
getxidremote
cd $BASEDIR

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"
YESTERDAY="$(date +%F -d yesterday)"

#
# Delete Dupliocate
#

CHECKSQL="$($SQLCRE_E "select sha512, count(sha512) as cnt from malwareinfo group by sha512 having cnt > 1 order by cnt" | awk '{print $1}')"

for a in $CHECKSQL ; do
	$BINARIES/reprocess.sh $a
	echo "$(date) found $a" >> $BASEDIR/logs/stillverydup.log
done

#
# Clean Processed Files, more then 30 days
#

#cd $STORAGE/processed
#POST="$(find . -name '*' -mtime +14)"

#echo "Clearning Processed Dump"

#for a in $POST ; do
#	echo $a
#	SHA1="$(echo $a | awk -F \/ '{print $2}' | awk -F . '{print $1}')"
#	rm $STORAGE/processed/$SHA1.tar.bz2
	
#done

echo "Clearning Daily Dump"

cd $STORAGE/daily
POST="$(find . -name '*' -mtime +14)"

for a in $POST ; do
        echo $a
        SHA="$(echo $a | awk -F \/ '{print $2}' | awk -F . '{print $1}')"
        rm $STORAGE/daily/$SHA.zip
done

#
# Daily Package
#

cd $STORAGE/daily
#mkdir xandora-$YESTERDAY

echo "Dump Yesterday Sample"

#find $STORAGE/samples -iname "*.zip" -mtime -1 -exec cp {} xandora-$YESTERDAY \;

7za a xandora-$YESTERDAY.zip $STORAGE/samples/$YESTERDAY

