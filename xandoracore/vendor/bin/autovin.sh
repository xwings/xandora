#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
FILENAME=""
URL=""
FOLDER=""
DOWNLOADPATH="$BASEDIR/vendor/autovin"
SOURCE="autovin"
FUID="11"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

ncftp -u autovin -p x4nd0ra7788 apac.pandasecurity.com <<END_SCRIPT
		bin
		mget *
		rm *
		bye
END_SCRIPT

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles
