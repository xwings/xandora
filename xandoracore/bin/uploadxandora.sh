#!/bin/sh
ncftp -u pushxandora -p m4lwar3ader x.xandora.net <<END_SCRIPT
	bin
	put $1
	bye
END_SCRIPT
