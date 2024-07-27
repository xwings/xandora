#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="`date +%b%d%G -d 'yesterday'`"
URL="`date +sonic-$FILENAME.zip`"
DOWNLOADPATH="$BASEDIR/vendor/sonicwall"
SOURCE="SonicWall"
FUID="3"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

wget --user=vendor --password=s0n1cWALLsh4r3 http://collections.eng.sonicwall.com/share/$URL

if [ -f $DOWNLOADPATH/$URL ]; then
        unzip -o -Pinfected $URL
        mv $DOWNLOADPATH/$FILENAME/* .
        rm $URL
        if [ -d $DOWNLOADPATH/$FILENAME ]; then
                rm -rf $DOWNLOADPATH/$FILENAME
        fi
fi

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles



