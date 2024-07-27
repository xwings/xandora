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

if [ -f $BASEDIR/logs/fetch.lock ]; then
        echo "$(date) ERROR: Another fetching process is running" >> $BASEDIR/logs/error.log
        exit
fi

touch $BASEDIR/logs/fetch.lock

#NEWSAMPLE="$BASEDIR/newfiles"
#cd $NEWSAMPLE

#find * -print0 | while read -d $'\0' file; do
#        mv $file sample`date +%N`
#        REP="$(($REP+10))"
#done

#NSMP="`(ls $NEWSAMPLE)`"
#
#if [ ! -z "${NSMP[0]}" ]; then
#        for a in $NSMP ; do

#				PARENT="$(echo $NEWSAMPLE/$a | awk -F \. '{print $2}')"
#				SHASUM="$(sha512sum $NEWSAMPLE/$a | awk '{print $1}')"
				
#				mkdir $BASEDIR/found/$SHASUM
#				mv $NEWSAMPLE/$a $BASEDIR/found/$SHASUM/$SHASUM
#				echo "Source: MGM" > $BASEDIR/found/$SHASUM/$SHASUM.info
#				echo "Original: $a" >> $BASEDIR/found/$SHASUM/$SHASUM.info
#				echo "Parent: $PARENT" >> $BASEDIR/found/$SHASUM/$SHASUM.info
								
#               cd $BASEDIR
#        done
#fi

rm $BASEDIR/logs/fetch.lock

### --- Fetch from WWW --- ###

#NEW="`(ls $WEBUPLOAD)`"
#if [ ! -z "${NEW[0]}" ]; then
#
#        cd $BASEDIR/found
#
#        for a in $NEW ; do
#
#               SHASUM="$(sha512sum $WEBUPLOAD/$a | awk '{print $1}')"
#              FUID="$(echo $WEBUPLOAD/$a | awk -F \. '{print $2}')"
#
#                if [ ! -d $BASEDIR/found/$SHASUM ]; then
#                       mkdir $BASEDIR/found/$SHASUM
#                        mv $WEBUPLOAD/$a $BASEDIR/found/$SHASUM/$SHASUM
#                        echo "FUID: $FUID" > $BASEDIR/found/$SHASUM/$SHASUM.info
#                        cp -r $BASEDIR/found/$SHASUM /root
#                fi
#                rm $WEBUPLOAD/$a
#
#        done
#fi

### --- maldbXchange --- ###

#cd $BASEDIR/mdbxchange
#perl $BINDIR/leechpop.pl -s malwaredatabase.net -u x@malwaredatabase.net -p FdoXn8H5z*C
#
#MDBX="`(ls $BASEDIR/mdbxchange)`"

#                FILETYPE="`file $BASEDIR/mdbxchange/$a | grep ASCII`"
#                if [ ! -z "$FILETYPE" ]; then   
#                        cd $BASEDIR/mdbxchange
#                        uudecode $a
#                        rm $a
#                        cd -
#                fi
	
### --- Fetch from MGM --- ###

### --- Fetch from FTP --- ###

#cd $SAMPLEDIR
#fetchftp malwareader m4lwar3ader sample.pandasecurity.com.my

#NEW="`(ls $SAMPLEDIR)`"
#if [ ! -z "${NEW[0]}" ]; then
#	cd $BASEDIR/found
#    for a in $NEW ; do
#    	echo  "Found $a">> $BASEDIR/logs/fetch.log
#        unzip -P panda $SAMPLEDIR/$a
#		rm -rf $SAMPLEDIR/$a
#	done
#fi

### --- Clear fetch lock--- ###

