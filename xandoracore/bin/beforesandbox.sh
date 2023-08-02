#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"
WORKINGDIR="$BASEDIR/ready"

## Checking and initializing
getinfo
cd $BASEDIR

#for a in $TOTALSERVER; do
#	if [ -d $BASEDIR/ready_lb/$a/$RUNSAMPLE ]; then
#		rm -rf $WORKINGDIR/$RUNSAMPLE
#	fi
#done

#MGMCHILD="$($SQLCRESINGLE "select count(md5_parent) from malwareinfo where md5_parent='$PARENT'")"
#if [ $MGMCHILD -gt 4 ]; then
#	rm -rf $WORKINGDIR/$RUNSAMPLE
#	exit
#fi

if [ -d $WORKINGDIR/$RUNSAMPLE ]; then
	cd $BASEDIR

	# VirusTotal Scanning
	(python $BINDIR/vt.py $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE) & sleep 15 ; kill $!

	# Just to make sure we are at home
	cd $BASEDIR

	#sudo chown -R $USER:$GROUP $WORKINGDIR/$RUNSAMPLE
	mkdir -p $WORKINGDIR/$RUNSAMPLE/mnt_vms
	mkdir -p $WORKINGDIR/$RUNSAMPLE/mnt_snap
	mkdir -p $WORKINGDIR/$RUNSAMPLE/mnt_changes

	cd $WORKINGDIR/$RUNSAMPLE


	# Adding information to .info file
	echo "File SHA1: $RUNSAMPLESHA1" >> $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info
	echo "File MD5 : $RUNSAMPLEMD5" >> $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info
	echo "File SHA512 : $RUNSAMPLE" >> $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info

	touch $WORKINGDIR/$RUNSAMPLE/ready.log
	
fi