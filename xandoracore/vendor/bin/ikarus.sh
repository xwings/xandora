#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="$(date +%G-%m-%d -d 'yesterday')"
URL="$FILENAME.zip"
DOWNLOADPATH="$BASEDIR/vendor/ikarus"
SOURCE="Ikarus"
FUID="16"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

wget --user=xandora --password=qewr\$37A http://fileexchange.ikarus.at/malware/daily-exchange/$URL

if [ -f $DOWNLOADPATH/$URL ]; then
        unzip -j -o -Pinfected $URL
        rm $URL
fi

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles
