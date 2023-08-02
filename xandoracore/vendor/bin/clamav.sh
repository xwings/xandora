#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
URL="$(date +%Y%m%d -d 'yesterday')"
FILENAME="snapshot-all-current.zip"
DOWNLOADPATH="$BASEDIR/vendor/clamav"
SOURCE="clamav"
FUID="8"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

wget --user=malwaredatabase --password=ETjgaaTx --no-check-certificate https://www.snapshot.clamav.net/all/$FILENAME

if [ -f $DOWNLOADPATH/$FILENAME ]; then
        unzip -o -Pinfected $FILENAME
        mv $DOWNLOADPATH/*/*/* .
        rm -rf snapshot-critical-current.*
fi

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles

if [ -d $DOWNLOADPATH ]; then
        cd $DOWNLOADPATH
        rm -rf *
fi