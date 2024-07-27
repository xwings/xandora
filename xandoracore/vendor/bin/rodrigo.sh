#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="$(date +%Y-%m-%d -d 'yesterday')"
URL="dissect-$FILENAME.tar.gz"
DOWNLOADPATH="$BASEDIR/vendor/rodrigo"
SOURCE="Rodrigo"
FUID="6"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

wget --ftp-user=panda --ftp-password=B1tch=y3s! ftp://ftp.dissect.pe/$URL

if [ -f $DOWNLOADPATH/$URL ]; then
        tar xvzf $URL
        rm $URL
fi

############ Do not edit after this line, unless you are *nix fan boy ################


renamefiles