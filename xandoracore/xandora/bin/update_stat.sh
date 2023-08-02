#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Checking and initializing

getinfo
getxidlocal
cd $BASEDIR

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"

HOUR="$(($(date +%k)-1))"
TIMELINE="$(date +%F)"

#
# reset count
#

echo "truncate stat_ip;" > $BASEDIR/conf/update_stat_x.sql
echo "truncate stat_domain;" >> $BASEDIR/conf/update_stat_x.sql
echo "truncate stat_country;" >> $BASEDIR/conf/update_stat_x.sql
echo "truncate stat_malware;" >> $BASEDIR/conf/update_stat_x.sql

echo "insert into stat_country(country, count) \
	     select trafficinfo.country, count(trafficinfo.country) \
	     as count from malwareinfo,trafficinfo where trafficinfo.xid=malwareinfo.xid and \
	     trafficinfo.country !='IP' and malwareinfo.cdate='$TIMELINE' group by country;" >> $BASEDIR/conf/update_stat_x.sql

echo "insert into stat_domain(domain, country, count) \
	     select trafficinfo.domain, trafficinfo.country, count(trafficinfo.domain) \
	     as count from malwareinfo,trafficinfo where trafficinfo.xid=malwareinfo.xid and \
	     trafficinfo.country !='IP' and trafficinfo.domain !='' and malwareinfo.cdate ='$TIMELINE' group by domain;" >> $BASEDIR/conf/update_stat_x.sql

echo "insert into stat_ip(ipv4, country, count) \
	     select trafficinfo.ipv4, trafficinfo.country, count(trafficinfo.ipv4) \
	     as count from malwareinfo,trafficinfo where trafficinfo.xid=malwareinfo.xid and trafficinfo.country !='IP' and trafficinfo.ipv4 != '192.228.128.18' and malwareinfo.cdate ='$TIMELINE' group by ipv4;" >> $BASEDIR/conf/update_stat_x.sql

echo "insert into stat_malware(name, count) \
	     select scaninfo.name, count(scaninfo.name) as count \
             from malwareinfo,scaninfo where malwareinfo.xid=scaninfo.xid  and malwareinfo.cdate ='$TIMELINE' group by scaninfo.name order by count desc;" >> $BASEDIR/conf/update_stat_x.sql

$SQL < $BASEDIR/conf/update_stat_x.sql