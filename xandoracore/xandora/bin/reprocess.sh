#!/bin/bash


### Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
RUNSAMPLE="$1"

## Checking and initializing
cd $BASEDIR

EXITS="$($SQLCRESINGLE "select sha512 from malwareinfo where sha512='$RUNSAMPLE' limit 1" | awk '{print $1}')"

if [ ! -z  $EXITS ]; then

    KILLID="$(ps aux | grep $RUNSAMPLE | grep aftersandbox.sh | awk '{print $2}')"
	if [ ! -z $KILLID ]; then
		echo "Kill Process $KILLID"
    	kill -9 $KILLID
	fi

	echo "Clearing Records"

    XID="$($SQLCRESINGLE "select xid from malwareinfo where sha512='$RUNSAMPLE' limit 1" | awk '{print $1}')"

    $SQLCRE "delete from generated_file where xid='$XID'"
    $SQLCRE "delete from registryinfo where xid='$XID'"
    $SQLCRE "delete from trafficinfo where xid='$XID'"
    $SQLCRE "delete from processinfo where xid='$XID'"
    $SQLCRE "delete from whitelist where xid='$XID'"
    $SQLCRE "delete from scaninfo where xid='$XID'"
    $SQLCRE "delete from fileuid where xid='$XID'"
 	$SQLCRE "delete from appearance where xid='$XID'"
 	$SQLCRE "delete from sharing where xid='$XID'"
 	$SQLCRE "delete from screenshot where xid='$XID'"
    $SQLCRE "delete from malwareinfo where xid='$XID'"



		
	echo "Cleaning Files"
	cd /tmp
	unzip -P infected $STORAGE/samples/$RUNSAMPLE.zip
	cp $RUNSAMPLE $BASEDIR/newfiles

	rm -f $STORAGE/processed/$RUNSAMPLE.tar.bz2
	rm -f $STORAGE/samples/$RUNSAMPLE.zip
	rm -rf $RUNSAMPLE
	
	cd $BASEDIR/logs
		rm "$(grep -r "$RUNSAMPLE" qemu-nbd* | awk -F: '{print $1}')"
	cd -
	
        if [ -d $BASEDIR/working/$RUNSAMPLE ]; then
				cp $BASEDIR/working/$RUNSAMPLE/$RUNSAMPLE $BASEDIR/newfiles
				rm -rf $BASEDIR/working/$RUNSAMPLE
        fi    

        if [ -d $BASEDIR/postsandbox/$RUNSAMPLE ]; then
				cp $BASEDIR/working/$RUNSAMPLE/$RUNSAMPLE $BASEDIR/newfiles
				rm -rf $BASEDIR/postsandbox/$RUNSAMPLE 
        fi

        if [ -d $BASEDIR/preport/$RUNSAMPLE ]; then
			cp $BASEDIR/preport/$RUNSAMPLE/$RUNSAMPLE $BASEDIR/newfiles
			rm -rf $BASEDIR/preport/$RUNSAMPLE
		fi


        if [ -d $BASEDIR/ready/$RUNSAMPLE ]; then
				cp $BASEDIR/working/$RUNSAMPLE/$RUNSAMPLE $BASEDIR/newfiles
				rm -rf $BASEDIR/ready/$RUNSAMPLE
        fi

        if [ -d $BASEDIR/found/$RUNSAMPLE ]; then
				cp $BASEDIR/working/$RUNSAMPLE/$RUNSAMPLE $BASEDIR/newfiles
				rm -rf $BASEDIR/found/$RUNSAMPLE
        fi

fi

