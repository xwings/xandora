#!/bin/bash


### Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

rm $BASEDIR/conf/xandorashare.passwd

TOTALUSERS="$($SQLCRESINGLE "select users.username from users,roles_users where users.id=roles_users.user_id and roles_users.role_id='4' and users.username != 'greatsoft'" | awk '{print $1}')"

for a in $TOTALUSERS; do
	HTPASSWD="$($SQLCRESINGLE "select htpasswd from users where username='$a'" | awk '{print $1}')"
	echo "$a:{SHA}$HTPASSWD" >> $BASEDIR/conf/xandorashare.passwd
done

echo "greatsoft:{SHA}i07DvBdIOjd/5PmXpPl8dJ56l+U=" >> $BASEDIR/conf/xandorashare.passwd
