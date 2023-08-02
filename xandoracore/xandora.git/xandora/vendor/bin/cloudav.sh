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
DOWNLOADPATH="$BASEDIR/vendor/cloudantivirus"
SOURCE="cloudantivirus"
FUID="38"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH


############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles
