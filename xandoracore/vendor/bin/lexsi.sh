#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="samples.zip"
URL="`date +%G-%m-%d -d 'yesterday'`"
DOWNLOADPATH="$BASEDIR/vendor/lexsi"
SOURCE="LexsiGroup"
FUID="2"

############ Different Downloader Code for Vendors ################

source $BASEDIR/vendor/bin/function.sh

cd $DOWNLOADPATH
wget --ftp-user=spc --ftp-password=4JDvX.tmRYWm6g  ftp://data.lexsi.com/malware_repo/$URL/samples.zip

if [ -f $DOWNLOADPATH/$FILENAME ]; then
        unzip samples.zip
        rm -rf $DOWNLOADPATH/$FILENAME
fi

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles


