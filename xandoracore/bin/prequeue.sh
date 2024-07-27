#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Checking and initializing
cd $BASEDIR

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"

## Locking fetching process

if [ -f $BASEDIR/logs/prequeue.lock ]; then
        echo "`date` ERROR: Another fetching process is running" >> $BASEDIR/logs/error.log
        exit
fi

touch $BASEDIR/logs/prequeue.lock
	
NEWMALWARE="$(ls $BASEDIR/found)"
if [ ! -z "${NEWMALWARE[0]}" ]; then
	for a in $NEWMALWARE ; do
		
	cd $BASEDIR/found

	SHASUM="$(sha512sum $a/$a | awk '{print $1}')"
	FILETYPE="$(cat $BASEDIR/found/$SHASUM/$SHASUM.info | grep Filetype | head -1 | awk '{print $2}')"
	
	if  [ -f $BASEDIR/found/$SHASUM/vendor.log ] && [ ! -z "$FILETYPE" ]; then
			presandbox $SHASUM $FILETYPE     
	fi
		cd $BASEDIR
    done
fi

### --- Clear fetch lock--- ###
rm $BASEDIR/logs/prequeue.lock
