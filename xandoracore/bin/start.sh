#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
NEWCOUNT="0"
CONCOUNT="0"

## Checking and initializing
getinfo
cd $BASEDIR

# -- Don't Change from Here --

# Process Check

if [ -f $BASEDIR/logs/malwareader.lock ]; then
	echo "!!!  DIED !!! `date` Another Process Running" >> $BASEDIR/logs/error.log
	exit
fi

echo "Starting start.sh"

touch $BASEDIR/logs/malwareader.lock

NEWMALWARE="`(ls $BASEDIR/ready)`"

if [ ! -z "${NEWMALWARE[0]}" ]; then
	
	for a in $NEWMALWARE ; do

		#if [ -d $BASEDIR/working/$a ] && [ -d $BASEDIR/ready/$a ] && [ -f $BASEDIR/ready/$a/scanned.log ]; then
		#	rm -rf $BASEDIR/ready/$a
		#fi
		
		RUNSAMPLEMD5="$(md5sum $BASEDIR/ready/$a/$a | awk '{print $1}')"
		RUNSAMPLESHA512="$(sha512sum $BASEDIR/ready/$a/$a | awk '{print $1}')"

		
		#MGMCHILD="$($SQLCRESINGLE_E "select count(xid_parent) from malwareinfo where xid_parent='$PARENT'")"
		#if [ $MGMCHILD -gt 4 ]; then
		#	rm -rf $BASEDIR/ready/$a
		#fi
		
		#if [ -d $BASEDIR/ready/$a ]; then
			PE32="$(file $BASEDIR/ready/$a/$a | grep executable | awk '{print $1}')"
		
        #	if [ -f $BASEDIR/ready/$a/$a.info ] && [ -z $PE32 ] && [ -f $BASEDIR/ready/$a/scanned.log ]; then
        #		echo "!!!!! ERROR: Autovin Cannot Process !!!!" >> $BASEDIR/logs/process.log
        #    	CUSTOMER="`cat $BASEDIR/ready/$a/$a.info | grep Email: | awk '{print $2}'`"
		#	
        #    	( /usr/bin/printf "Hello,\n\n" \
		#  		; /usr/bin/printf "File that you just uploaded is not a valid executable file.\n" \
		#  		; /usr/bin/printf "Xandora did not process this file.\n" \
		#  		; /usr/bin/printf "Feedback: feedback@xandora.net\n" \
		#  		; /usr/bin/printf "Xandora Team") \
		#		| mail -a "From: Xandora <feedback@xandora.net>" -s "File Not Accepted" $CUSTOMER
        #                
		#		rm -rf $BASEDIR/ready/$a
		#	fi
		#fi
		
        if [ -d $BASEDIR/ready/$a ] && [ -f $BASEDIR/ready/$a/scanned.log ]; then
				startsandbox _pre 0                                                                        
				startsandbox 0 1
                startsandbox 1 2                                                                                                  
				startsandbox 2 3
                startsandbox 3 4                                                                          
                startsandbox 4 5
                startsandbox 5 6
                startsandbox 6 7
                startsandbox 7 8
                startsandbox 8 9
                startsandbox 9 10
                startsandbox 10 11
                startsandbox 11 12
                startsandbox 12 13
                startsandbox 13 14
                startsandbox 14 15
                startsandbox 15 16
                startsandbox 16 17
                startsandbox 17 18
				if [ "$FUID" == "11" ] || [ "$FUID" == "21" ] || [ "$FUID" == "38" ]; then
                	startsandbox 18 19  
				fi
			fi
		
	done
else
	echo "Found Nothing"
fi


echo "Remove malwareader.lock"
rm -rf  $BASEDIR/logs/malwareader.lock
echo "#### ----- END : `date` ---- ####"
