#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
STORAGE="/home/xandora"
BINDIR=$BASEDIR"/bin"
YESTERDAY="$(date +%Y%m%d -d 'yesterday')"
FILENAME=""
DOWNLOADPATH="$BASEDIR/vendor/panda"
SOURCE="panda"
FUID="13"

DBUSER="xandora"
DBPASSWD="xandora789"
DBNAME="xandora"
SQL="mysql -u $DBUSER -p$DBPASSWD -f $DBNAME"
SQLCRE="mysql -u $DBUSER -p$DBPASSWD $DBNAME -e"
SQLCRESINGLE="mysql -u $DBUSER -p$DBPASSWD $DBNAME -sN -e"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

if [ -d $DOWNLOADPATH/result ]; then

        cd $DOWNLOADPATH/result

		POST="$(find . -name '*' -mtime +7)"        
        for a in $POST ; do
                SHA="$(echo $a | awk -F \/ '{print $2}' | awk -F . '{print $1}')"
                rm $DOWNLOADPATH/result/$SHA.tar.bz2
        done
        
		TOTAL="$($SQCRE "select malwareinfo.sha512 from malwareinfo,fileuid where malwareinfo.xid=fileuid.xid and malwareinfo.cdate='$YESTERDAY' and fileuid.user_id='$FUID' and malwareinfo.status='Done';")"
        for a in $TOTAL; do
                cp $STORAGE/processed/$a.tar.bz2 .
        done
fi

cd $DOWNLOADPATH/Panda
mv * $DOWNLOADPATH/process

cd $DOWNLOADPATH/process

LIST="$(ls $DOWNLOADPATH/process)"
if [ ! -z "${LIST[0]}" ]; then
	for a in $LIST; do
		SHA="$(sha512sum $a | awk '{print $1}')"

		if [ ! -z $a ] && [ -f $STORAGE/processed/$a.tar.bz2 ]; then
			cp $STORAGE/processed/$a.tar.bz2 $DOWNLOADPATH/result/
			rm $a
		fi
		
		SEEN="$($SQLCRESINGLE "select sha512 from malwareinfo where sha512='$a' and status = 'Done' limit 1" | awk '{ print $1 }')"
        if [ ! -z $SEEN ] && [ ! -f $STORAGE/processed/$a.tar.bz2 ] && [ -f $DOWNLOADPATH/process/$a ]; then
                $BASEDIR/bin/reprocess $a
                if [ -f $BASEDIR/vendor/redo/$a ]; then
                        mv $BASEDIR/vendor/redo/$a $DOWNLOADPATH/process
                fi
        fi
        

	done
fi

DOWNLOADPATH="$DOWNLOADPATH/process"
cd $DOWNLOADPATH


############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles
