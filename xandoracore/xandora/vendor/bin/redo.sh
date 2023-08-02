#!/bin/bash

#
# Downloader for vendors
#

PATH="$BINIRIES:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"
BASEDIR="/opt/malwareader"
BINDIR=$BASEDIR"/bin"
DOWNLOADPATH="$BASEDIR/vendor/redo"
SOURCE="redo"
FUID="21"

source $BASEDIR/vendor/bin/function.sh

############ Different Downloader Code for Vendors ################

cd $DOWNLOADPATH

############ Do not edit after this line, unless you are *nix fan boy ################

renamefiles