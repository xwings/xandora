#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="$(date +%G-%m-%d -d 'yesterday')"
URL="anubis_$FILENAME.tar.gz"
FOLDER="anubis_$FILENAME"
DOWNLOADPATH="$BASEDIR/vendor/anubis"
SOURCE="Anubis"
FUID="8"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

wget --user=xandora --password=Ee1vu6ah https://anubis.iseclab.org/my_sample_dumps/$URL

if [ -f $DOWNLOADPATH/$URL ]; then
    tar xvzf $URL
	rm $URL
	cp $FOLDER/* .
	rm -rf $FOLDER
fi

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles
