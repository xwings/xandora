## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"
SPOOLDIR="$BASEDIR/ready"
LBDIR="$BASEDIR/ready_lb"

## Checking and initializing
getinfo
cd $BASEDIR

if [ -f $BASEDIR/logs/ready_lb.lock ]; then
	echo "!!!  DIED !!! `date` Another Process Running" >> $BASEDIR/logs/error.log
	exit
fi

touch $BASEDIR/logs/ready_lb.lock


TOTALSPOOL="$(ls $SPOOLDIR)"

for a in $TOTALSPOOL ; do 
	for b in $TOTALSERVER ; do 
		if [ "$c" != "$b" ] && [ -d $SPOOLDIR/$a ] && [ -f $SPOOLDIR/$a/ready.log ] && [ ! -f $SPOOLDIR/$a/scanned.log ]; then
			
			if [ "$c" == "ready_1" ]; then
				b="ready_2"
			fi
			
			mv $SPOOLDIR/$a $LBDIR/$b
			touch $LBDIR/$b/$a/scanned.log
			c=$b
		fi
	done
done

rm $BASEDIR/logs/ready_lb.lock



		