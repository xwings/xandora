#!/bin/bash

#
# Downloader for vendors
# 

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME="`date +%G-%m-%d.rar -d 'yesterday'`"
URL="`date +%G-%m-%d.rar.pgp -d 'yesterday'`"
DOWNLOADPATH="$BASEDIR/vendor/kingsoft"
SOURCE="KingSoft"
FUID="3"

############ Different Downloader Code for Vendors ################

source $BASEDIR/vendor/bin/function.sh

cd $DOWNLOADPATH

wget --ftp-user=kwebftp --ftp-password=36DI2n6ZQ4hP7YrL ftp://202.65.213.250/ksday/$URL

if [ -f $DOWNLOADPATH/$URL ]; then
	echo "k4ij3rn" | gpg --batch --decrypt --passphrase-fd 0 --output $FILENAME $URL
        unrar x $FILENAME
	rm $URL
	rm *.txt
	rm $FILENAME
fi


############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles

