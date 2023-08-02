#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh


cd $BASEDIR

if [ "$1" == "day" ]; then
        $SQLCRE "update stat_counter set totaltoday='0';"
elif [ "$1" == "week" ]; then
        $SQLCRE "update stat_counter set totalweek='0';"
elif [ "$1" == "month" ]; then
        $SQLCRE "update stat_counter set totalmonth='0';"
fi