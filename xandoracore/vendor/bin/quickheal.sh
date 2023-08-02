#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="$(date +%G-%m-%d -d 'yesterday')"
URL="$FILENAME.ZIP"
DOWNLOADPATH="$BASEDIR/vendor/quickheal"
SOURCE="QuickHeal"
FUID="4"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

wget --user=download --password=6BnM8FbNt7 http://malwarelab.quickheal.com/daily-share/$URL

if [ -f $DOWNLOADPATH/$URL ]; then
        unzip -o -Pinfected $URL
        rm $URL
fi

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles
