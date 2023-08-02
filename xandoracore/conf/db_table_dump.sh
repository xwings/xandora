#!/bin/bash
# script to backup db schema changes, if you make changes to db schema, please
# run this script and commit to github
# only works with bash!

DB='xandora'
DBUSER='xangui'
DBPASS='xangui123'

NOW=$(date +"%Y%m%d")
DBFILENAME="xandora-$NOW.sql"

if [ -f $DBFILENAME ]
then
    rm $DBFILENAME
fi

lookuptables=( _antivirus_company _country _file_extension _infection_method _registry_action _registry_category _update_method roles roles_users users user_tokens)
for lookuptable in "${lookuptables[@]}"
	do
	    mysqldump -u $DBUSER -p$DBPASS $DB $lookuptable >> $DBFILENAME
    	done

tables=( malwareinfo processinfo generated_file registryinfo scaninfo
    screenshot static_header trafficinfo whitelist behaviourinfo updateinfo
    stat_country stat_domain stat_ip stat_malware fileuid appearance sharing)
 for table in "${tables[@]}"
 	do
        	mysqldump -d -u $DBUSER -p$DBPASS $DB $table >> $DBFILENAME
	done
