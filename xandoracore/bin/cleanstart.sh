#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Checking and initializing
getinfo
getxidlocal
cd $BASEDIR

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"

## Delete Dupliocate

CHECKSQL="$($SQLCRE "select sha512 from malwareinfo where status !='Done' and status !='Ready' and status not like '%Done'" | awk '{print $1}')"

for a in $CHECKSQL ; do
	$BINARIES/reprocess.sh $a
done

cd $BASEDIR/logs
	rm dynamicdump* fetch.lock malwareader.lock qemu-nbd*
	rm /var/lock/qemu-nbd-nbd*
cd -
