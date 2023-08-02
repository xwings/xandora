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
YESTERDAY="$(date +%F -d yesterday)"

#
# Stats
#


TOTAL_AV="$($SQLCRESINGLE "select id from  _antivirus_company;")"

for a in $TOTAL_AV; do
	AVCOUNT="$($SQLCRESINGLE "select count(scaninfo.antivirus_company) from malwareinfo,scaninfo where scaninfo.xid=malwareinfo.xid and malwareinfo.cdate='$YESTERDAY' and scaninfo.antivirus_company='$a'")"
	AVNAME="$($SQLCRESINGLE "select name from  _antivirus_company where id ='$a'")"
	echo "$AVNAME        : $AVCOUNT" >> $BASEDIR/logs/totalscanner.log
done

TOTAL="$($SQLCRESINGLE "select count(xid) from malwareinfo where cdate='$YESTERDAY'")"
TOTALURL="$($SQLCRESINGLE "select count(id) from malwareinfo,trafficinfo where malwareinfo.xid=trafficinfo.xid and trafficinfo.port='80' and cdate='$YESTERDAY';")"
TOTALACC="$($SQLCRESINGLE "select users.username from users,roles,roles_users where users.id=roles_users.user_id and roles.id=roles_users.role_id and role_id='4';")"

for a in $TOTALACC; do
	UNIQ_UPLOAD="$($SQLCRESINGLE "select count(fileuid.xid) from malwareinfo,fileuid,users where fileuid.xid=malwareinfo.xid and fileuid.user_id=users.id and users.username='$a' and malwareinfo.cdate='$YESTERDAY';")"
	DUP_UPLOAD="$($SQLCRESINGLE "select count(appearance.xid) from malwareinfo,users,appearance where appearance.xid=malwareinfo.xid and appearance.user_id=users.id and users.username='$a' and malwareinfo.cdate='$YESTERDAY';")"

	TOTALUPLOAD="$(($UNIQ_UPLOAD+$DUP_UPLOAD))"
    echo "$a        : $TOTALUPLOAD (Uniq: $UNIQ_UPLOAD || Dup: $DUP_UPLOAD)" >> $BASEDIR/logs/totalupload.log

done

TOTALPUB="public autotvin cloudantivirus generated"

for a in $TOTALPUB; do
	UNIQ_UPLOAD="$($SQLCRESINGLE "select count(fileuid.xid) from malwareinfo,fileuid,users where fileuid.xid=malwareinfo.xid and fileuid.user_id=users.id and users.username='$a' and malwareinfo.cdate='$YESTERDAY';")"
	DUP_UPLOAD="$($SQLCRESINGLE "select count(appearance.xid) from malwareinfo,users,appearance where appearance.xid=malwareinfo.xid and appearance.user_id=users.id and users.username='$a' and malwareinfo.cdate='$YESTERDAY';")"

	TOTALUPLOAD="$(($UNIQ_UPLOAD+$DUP_UPLOAD))"
    echo "$a        : $TOTALUPLOAD (Uniq: $UNIQ_UPLOAD || Dup: $DUP_UPLOAD)" >> $BASEDIR/logs/totalupload.log

done


( /usr/bin/printf "Report for $YESTERDAY,"\
  ; /usr/bin/printf "\n\n\n" \
  ; echo "Total Files   : $TOTAL"  \
  ; echo "Total URL     : $TOTALURL" \
  ; printf "\n\n\n" \
  ; echo "$(cat $BASEDIR/logs/totalupload.log)" \
  ; printf "\n\n\n" \
  ; echo "$(cat $BASEDIR/logs/totalscanner.log)" \
  ; printf "\n\n" ) \
| mail -a "From: KaiJern <kj@xandora.net>" -c "ts@apac.pandasecurity.com" -s "Stats For: $YESTERDAY" kj@apac.pandasecurity.com



#
# Dump SQL
#


$SQLCRE "select malwareinfo.cdate, malwareinfo.ctime, malwareinfo.md5, trafficinfo.url from malwareinfo,trafficinfo where trafficinfo.xid=malwareinfo.xid and trafficinfo.port ='80' and malwareinfo.cdate='$YESTERDAY';" | awk '{ print "\""$1" "$2"\""";""\""$3"\""";""\""$4"\""}' > /tmp/urlfor_$YESTERDAY.log
( /usr/bin/printf "xandora.net URL Dump for $YESTERDAY,"\
  ; printf "$DISCLAIMER" \
  ; echo "$(cat /tmp/urlfor_$YESTERDAY.log)" ) \
  | mail -a "From: kj@xandora.net <kj@xandora.net>" -s "xandora.net URL Dump for: $YESTERDAY" $SHAREURL


#
# Cleanup
#

rm /tmp/urlfor_$YESTERDAY.log
rm $BASEDIR/logs/totalupload.log
rm $BASEDIR/logs/totalscanner.log
