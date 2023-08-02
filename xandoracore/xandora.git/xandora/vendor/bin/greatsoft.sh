#!/bin/bash

#
# Downloader for vendors
# 

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="$(date +G%g%m%d- -d 'yesterday')"
DOWNLOADPATH="$BASEDIR/vendor/greatsoft"
SOURCE="greatsoft"
FUID="40"

############ Different Downloader Code for Vendors ################

source $BASEDIR/vendor/bin/function.sh

cd $DOWNLOADPATH

SEQ="0 1 2"

for a in $SEQ; do
        
        cd $DOWNLOADPATH
        wget --user=tencent --password=AV@kyle.Ex http://58.60.11.225:9328/Download/$FILENAME$a.rar

        if [ -f $DOWNLOADPATH/$FILENAME$a.rar ]; then
                unrar x $FILENAME$a.rar
                renamefiles
                rm $FILENAME$a.rar
        fi
done

############ Do not edit after this line, unless you are *nix fan boy ################

