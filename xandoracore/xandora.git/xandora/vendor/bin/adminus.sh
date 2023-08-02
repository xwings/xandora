#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
DFOLDER="$(date +%Y-%m-%d -d 'yesterday')"
DOWNLOADPATH="$BASEDIR/vendor/adminus"
SOURCE="adminus"
FUID="51"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

C="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"

for a in $C; do
	wget --ftp-user=xandora --ftp-password=kjxandora2011 ftp://87.249.110.179/Download/$DFOLDER/$DFOLDER-$a.zip

	if [ -f $DOWNLOADPATH/$DFOLDER-$a.zip ]; then
        	unzip -o -Pmalware $DFOLDER-$a.zip
    		rm $DFOLDER-$a.zip
	fi

done

############ Do not edit after this line, unless you are *nix fan boy ################


renamefiles