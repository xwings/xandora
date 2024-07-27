#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"

## Checking and initializing
getinfo
getxidremote
cd $BASEDIR

### --- PostSandbox --- ###

if [ -f $BASEDIR/logs/postreport.lock ]; then
	echo "!!!  DIED !!! `date` Another Process Running" >> $BASEDIR/logs/error.log
	echo "!!!  DIED !!! `date` Another Process Running"
	exit
fi

echo "create postreport.lock"
touch $BASEDIR/logs/postreport.lock

echo "Check file $BASEDIR/preport"
POSTSANDBOX="$(ls $BASEDIR/preport)"

echo "Found $POSTSANDBOX"
if [ ! -z "${POSTSANDBOX[0]}" ]; then
        
        for b in $POSTSANDBOX ; do
                cd $BASEDIR

                QDEV=""
                QDEVP1=""

		                if [ ! -f $BASEDIR/logs/qemu-nbd0.lock ] &&
		 		   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
								QDEV=nbd0       
		                        QDEVP1=1030   
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd0.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd1.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd1       
		                        QDEVP1=1031       
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd1.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd2.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd2       
		                        QDEVP1=1032       
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd2.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd3.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd3       
		                        QDEVP1=1033      
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd3.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd4.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd4
		                        QDEVP1=1034
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd4.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd5.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd5
		                        QDEVP1=1035
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd5.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd6.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd6
		                        QDEVP1=1036
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd6.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd7.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd7
		                        QDEVP1=1037
		                fi

		               	if [ -f $BASEDIR/logs/qemu-nbd7.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd8.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                       QDEV=nbd8
		                       QDEVP1=1038
		               	fi

		                if [ -f $BASEDIR/logs/qemu-nbd8.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd9.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd9
		                        QDEVP1=1039
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd9.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd10.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd10
		                        QDEVP1=1040
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd10.lock ] &&
		                   [ ! -f $BASEDIR/logs/qemu-nbd11.lock ] &&
				   [ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd11       
		                        QDEVP1=1041      
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd11.lock ] &&
		                   	[ ! -f $BASEDIR/logs/qemu-nbd12.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd12
		                        QDEVP1=1042
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd12.lock ] &&
		                   	[ ! -f $BASEDIR/logs/qemu-nbd13.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd13
		                        QDEVP1=1043
		                fi

		                if [ -f $BASEDIR/logs/qemu-nbd13.lock ] &&
		                   	[ ! -f $BASEDIR/logs/qemu-nbd14.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=nbd14
		                        QDEVP1=1044
		                fi

						if [ -f $BASEDIR/logs/qemu-nbd14.lock ] &&
				   			[ ! -f $BASEDIR/logs/qemu-nbd15.lock ] &&
				   			[ "$FUID" == "11" ] || [ "$FUID" == "21" ] || [ "$FUID" == "38" ] &&	
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
								QDEV=nbd15
								QDEVP1=1045
							fi


		                if [ -f $BASEDIR/logs/qemu-nbd15.lock ] &&
				   			[ -z $QDEV ] && [ -z $QDEVP1 ]; then
		                        QDEV=""       
		                        QDEVP1=""    
		                fi


				SIZE="$(df -h $BASEDIR/postsandbox | grep postsandbox | grep none | awk '{print $5}' | awk -F % '{print $1}')"
                FILETYPE="$(cat $BASEDIR/preport/$b/$b.info | grep Filetype | head -1 | awk '{print $2}')"
                if [ ! -z "$FILETYPE" ]  &&
                #        [ $SIZE -lt 90 ] &&
                        [ ! -f $BASEDIR/preport/$b/$b.lock ] &&
                        [ -f $BASEDIR/preport/$b/sandbox.lock ] &&
                        [ ! -z $QDEV ] &&
                        [ ! -z $QDEVP1 ]; then
								echo "Start $QDEV $QDEVP1"
                                touch $BASEDIR/logs/qemu-$QDEV.lock
								echo "$b" > $BASEDIR/logs/qemu-$QDEV.lock
								touch $BASEDIR/preport/$b/$b.lock
								mv $BASEDIR/preport/$b $BASEDIR/postsandbox
                                $BINDIR/aftersandbox.sh $b $FILETYPE $QDEV $QDEVP1 &
                fi
        done
fi

echo "delete postreport.lock"
rm $BASEDIR/logs/postreport.lock
