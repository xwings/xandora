
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh

function presandbox () {
	if [ ! -d $BASEDIR/ready/$1 ]; then
		touch $BASEDIR/found/$1/presandbox.log
		printf "\n\n" >> $BASEDIR/found/$1/$1.info
		mv $BASEDIR/found/$1 $BASEDIR/ready/
	   	$BINDIR/beforesandbox.sh $1 $2 &
	fi
	}

function startsandbox () {
	if      [ -f $BASEDIR/ready/$a/scanned.log ] &&
			[ -f $BASEDIR/logs/dynamicdump$1.lock ] &&
			[ ! -f $BASEDIR/logs/dynamicdump$2.lock ]; then

		if [ -d $BASEDIR/ready/$a ]; then

			echo "start sandbox ID: $2"
			cd $BASEDIR                                                
			cp -aRp $BASEDIR/ready/$a $BASEDIR/working
			rm -rf $BASEDIR/ready/$a
			sleep 10
			
			FILETYPE="$(cat $BASEDIR/working/$a/$a.info | grep Filetype | head -1 | awk '{print $2}')"
			if [ ! -z "$FILETYPE" ]; then
				echo "$a" > $BASEDIR/logs/dynamicdump$2.lock
				$BINDIR/dynamicdump.sh $a $FILETYPE $2 &
			#else
            #    rm -rf $BASEDIR/working/$a
            fi
		fi
	fi
}

function s3uploadsc () {
        SCREENID="$1"
        if [ -f $WORKINGDIR/$RUNSAMPLE/$SCREENID.jpg ]; then
                REP="$(($REP+3))"
                convert -size 640x480 $WORKINGDIR/$RUNSAMPLE/$SCREENID.jpg $WORKINGDIR/$RUNSAMPLE/$SCREENID.jpg
                mv $WORKINGDIR/$RUNSAMPLE/$SCREENID.jpg $WORKINGDIR/$RUNSAMPLE/$SCREENID-$RUNSAMPLEMD5.jpg
                s3cmd -c $BASEDIR/conf/s3.cfg put --acl-public $WORKINGDIR/$RUNSAMPLE/$SCREENID-$RUNSAMPLEMD5.jpg s3://xandora/screenshot/$SCREENID-$RUNSAMPLEMD5.jpg
                #printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
                #echo "$SCREENID" >> $WORKINGDIR/$RUNSAMPLE/report.txt
                #echo "<img src=\"http://x.xandora.net/wp-content/uploads/screenshots/$SCREENID_$RUNSAMPLEMD5.jpg\" />" >> $WORKINGDIR/$RUNSAMPLE/report.txt
                echo \
                "INSERT INTO screenshot (xid, filename) VALUES ('$XID','$SCREENID-$RUNSAMPLEMD5.jpg');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
        fi
}

	
function getxidlocal () {
	#XID="$($SQLCRESINGLE "select xid from malwareinfo where md5='$RUNSAMPLEMD5' limit 1" | awk '{print $1}')"
	XID="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info | grep XID: | awk '{print $2}')"
    
}

function getxidremote () {
	#XID="$($SQLCRESINGLE_E "select xid from malwareinfo where md5='$RUNSAMPLEMD5' limit 1" | awk '{print $1}')"
	XID="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info | grep XID: | awk '{print $2}')"
}

function getinfo () {

	if [ ! -z "$RUNSAMPLE" ]; then
		FUID="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info | grep FUID: | awk '{print $2}')"
		FILETYPE="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info | grep Filetype | awk '{print $2}')"
		PARENT="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.info | grep Parent | awk '{print $2}')"
		RUNSAMPLEMD5="$(md5sum $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE | awk '{print $1}')"
		RUNSAMPLESHA1="$(sha1sum $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE | awk '{print $1}')"
		RUNSAMPLESHA512="$(sha512sum $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE | awk '{print $1}')"
		PEID="$(python $BASEDIR/peid/packerid.py $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE | awk -F \' '{print $2}' & sleep 5 ; kill $!)"
		FTYPE="$(file $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE | awk -F : '{print $2}')"
		FILESIZE="$(du -b $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE | awk '{print $1}')"
		DATE="$(date +%F)"
		TIME="$(date +%R)"
		if [ "$FILETYPE" == "exe" ]; then
			EXTDB="1"
		elif [ "$FILETYPE" == "dll" ]; then
			EXTDB="2"
		fi
	fi
}


function genregistry () {
	echo "<strong>[$1]</strong>" >> $WORKINGDIR/$RUNSAMPLE/report.txt
	diff -c $2 $3 | grep -v "sample." | grep -v 'DiskQEMU_HARDDISK' | grep -v "^*" | grep -v "^---" | grep -e "[+,\[,a-z,A-Z,\]]" >> $WORKINGDIR/$2/report.txt

}

function insertregadd () {
        SYSTEMDIFF="$(diff -c $1 $2 | grep -v "sample." | grep -v 'WBEM' | grep -v 'Cryptography' | grep -v 'ClientProtocols' | grep  -v 'DiskQEMU_HARDDISK' | grep -v "^*" \
        | grep -v "^---" | grep -e "^+ \[" | grep -v "\!" | grep -e "[+,\[,a-z,A-Z,\]]" | grep -v "'" | sed -e 's/^+ //g' \
        | sed -e 's/ /_/g' | sed  -e 's/\\/_/g' | sed -e 's/\]//g' | sed -e 's/\[//g' )"

        for f in $SYSTEMDIFF ; do
                DIFFREG="$(echo $f | strings | grep -v "^-_" | grep -v "software_Classes" | grep -v "system_ControlSet" | grep -v "AntiWPA" | grep -v "Windows_Genuine_Advantage")"
                if [ ! -z "$DIFFREG" ]; then
                        REP="$(($REP+1))"
                        echo \
                                "INSERT INTO registryinfo (xid, registry_key, registry_content, category, action) \
                                VALUES ('$4','$DIFFREG','','$3','1');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
                fi
        done
}

function insertregdel () {
        SYSTEMDIFF="$(diff -c $1 $2 | grep -v "sample." | grep -v 'WBEM' | grep -v 'Cryptography' | grep -v 'ClientProtocols' | grep  -v 'DiskQEMU_HARDDISK' | grep -v "^*" | grep -v "'" \
                    | grep -v "^---" | grep -v "^+ \[" | grep -v "\!" | grep -e "[+,\[,a-z,A-Z,\]]" | sed -e 's/^  //g' \
                    | sed -e 's/ /_/g' | sed  -e 's/\\/_/g' | sed -e 's/\]//g' | sed -e 's/\[//g'))"

        for f in $SYSTEMDIFF ; do
                DIFFREG="$(echo $f | strings | grep -v "^-_" | grep -v "software_Classes"| grep -v "system_ControlSet" | grep -v "AntiWPA" | grep -v "Windows_Genuine_Advantage")"
                if [ ! -z "$DIFFREG" ]; then
                        REP="$(($REP+1))"
                        echo \
                                "INSERT INTO registryinfo (xid, registry_key, registry_content, category, action) \
                                VALUES ('$4','$DIFFREG','','$3','2');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
                fi
        done
}


function fetchftp () {
ncftp -u $1 -p $2 $3 <<END_SCRIPT
		bin
		mget *
		rm *
		bye
END_SCRIPT
}
