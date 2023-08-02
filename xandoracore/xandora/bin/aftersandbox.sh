#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"
QDEV="$3"
QDEVP1="$4"
WORKINGDIR="$BASEDIR/postsandbox"

## Checking and initializing
getinfo
getxidremote
cd $BASEDIR

## Inset FUID
#echo "INSERT INTO fileuid (xid, user_id) VALUES ('$XID','$FUID');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql

## Mount Image

qemu-nbd --read-only --partition=1  -p $QDEVP1 -b 127.0.0.1 --snapshot $WORKINGDIR/$RUNSAMPLE/sandbox.qcow2 &
sleep 2
nbd-client localhost $QDEVP1 /dev/$QDEV
sleep 2
ntfs-3g /dev/$QDEV $WORKINGDIR/$RUNSAMPLE/mnt_snap -o loop,ro,force
sleep 2

# debug network

if [ -f $WORKINGDIR/$RUNSAMPLE/mnt_snap/workspace/network.log ]; then
        cp $WORKINGDIR/$RUNSAMPLE/mnt_snap/workspace/network.log /tmp/networklog.$RUNSAMPLE
fi

#
# -- Registries Pre --
#

SOFTWAREregistries="/WINDOWS/system32/config/software"
SYSTEMregistries="/WINDOWS/system32/config/system"
SECURITIESregistries="/WINDOWS/system32/config/SECURITY"
SAMregistries="/WINDOWS/system32/config/SAM"
DEFAULTregistries="/WINDOWS/system32/config/default"
NTUSERregistries="/Documents*/Administrator/NTUSER.DAT"

$BINARIES/dumphive $BASEDIR/vms/mnt_good$SOFTWAREregistries $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-pre.txt
$BINARIES/dumphive $BASEDIR/vms/mnt_good$SYSTEMregistries $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-pre.txt
$BINARIES/dumphive $BASEDIR/vms/mnt_good$SECURITIESregistries $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-pre.txt
$BINARIES/dumphive $BASEDIR/vms/mnt_good$SAMregistries $WORKINGDIR/$RUNSAMPLE/SAMregistries-pre.txt
$BINARIES/dumphive $BASEDIR/vms/mnt_good$DEFAULTregistries $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-pre.txt
$BINARIES/dumphive $BASEDIR/vms/mnt_good$NTUSERregistries $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-pre.txt


#
# -- Registries Post --
#

$BINARIES/dumphive $WORKINGDIR/$RUNSAMPLE/mnt_snap$SOFTWAREregistries $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-post.txt
$BINARIES/dumphive $WORKINGDIR/$RUNSAMPLE/mnt_snap$SYSTEMregistries $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-post.txt
$BINARIES/dumphive $WORKINGDIR/$RUNSAMPLE/mnt_snap$SECURITIESregistries $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-post.txt
$BINARIES/dumphive $WORKINGDIR/$RUNSAMPLE/mnt_snap$SAMregistries $WORKINGDIR/$RUNSAMPLE/SAMregistries-post.txt
$BINARIES/dumphive $WORKINGDIR/$RUNSAMPLE/mnt_snap$DEFAULTregistries $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-post.txt
$BINARIES/dumphive $WORKINGDIR/$RUNSAMPLE/mnt_snap$NTUSERregistries $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-post.txt

diff -qr $BASEDIR/vms/mnt_good $WORKINGDIR/$RUNSAMPLE/mnt_snap > $WORKINGDIR/$RUNSAMPLE/generatedfiles.txt

cd $WORKINGDIR

## Generate Report

DIFF="$(cat $WORKINGDIR/$RUNSAMPLE/generatedfiles.txt | grep -v "sample.$FILETYPE" | grep -v "workspace" | grep Only | grep mnt_snap |awk -F mnt_snap '{print $2}' |sed -e 's/ /___/g')"


for c in $DIFF ; do
        d="$(echo $c | sed -e 's/___/\\ /g' | sed -e 's/:\\ /\//g' | sed -e 's/\[/\\[/g' | sed -e 's/\]/\\]/g')"


                GENFILESHA512="$(sha512sum "$WORKINGDIR/$RUNSAMPLE/mnt_snap$d" | awk '{print $1}')"
                GENFILEMD5="$(md5sum "$WORKINGDIR/$RUNSAMPLE/mnt_snap$d" | awk '{print $1}')"
                GENFILESIZE="$(du "$WORKINGDIR/$RUNSAMPLE/mnt_snap$d" | awk '{print $1}')"
                GENFILEINFO="$(file -b "$WORKINGDIR/$RUNSAMPLE/mnt_snap$d")"
                GENFILECHECK="$(file -b "$WORKINGDIR/$RUNSAMPLE/mnt_snap$d" | grep executable | grep -v DLL)"

                echo "$d $SHA512SUM" >> $WORKINGDIR/$RUNSAMPLE/sgeneratedfiles.txt

        #-- SQL --

        if [ ! -z $GENFILESHA512 ] && [ ! -z $GENFILEMD5 ] && [ "$GENFILEINFO" != "directory" ]; then
                cp "$WORKINGDIR/$RUNSAMPLE/mnt_snap$d" $WORKINGDIR/$RUNSAMPLE/mnt_changes/$GENFILEMD5
                echo "INSERT INTO generated_file (xid, filename, sha512, md5, filesize, ext) \
                        VALUES ('$XID','\"$d\"','$GENFILESHA512','$GENFILEMD5','$GENFILESIZE','1');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
        fi
        #

done

# -- Time to disconnect --

NTFS_PID="$(ps aux | grep ntfs-3g | grep $RUNSAMPLE | awk '{print $2}')"
kill -9 $NTFS_PID
sleep 2

sudo umount -l -f $WORKINGDIR/$RUNSAMPLE/mnt_snap
sleep 2
nbd-client -d /dev/$QDEV


# -- Static Information --

($BASEDIR/perdr/perdr -h $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE >> $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.static) & sleep 2 ; kill $!
python $BASEDIR/peid/packerid.py $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE >> $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.peid

SHEADER="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.static | grep -v "Build Oct  8 2006")"
PEID="$(cat $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.peid | awk -F \' {'print $2'})"

echo "INSERT INTO static_header (xid, header, peid) VALUES ('$XID','$SHEADER','$PEID');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql

#
# Malware Information
#

(python $BINARIES/vt_noupload.py $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE > $WORKINGDIR/$RUNSAMPLE/vtr.log) & sleep 15 ; kill $!
python $BINARIES/vt_noupload.py $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE > $WORKINGDIR/$RUNSAMPLE/vtr.log
cat $WORKINGDIR/$RUNSAMPLE/vtr.log | awk -F \{ '{print $2}' | awk -F \} '{print $1}' | sed -e "s/'//g" | sed 's/,/\n/g' > $WORKINGDIR/$RUNSAMPLE/vt.log
rm $WORKINGDIR/$RUNSAMPLE/vtr.log

FOUND="$(cat $WORKINGDIR/$RUNSAMPLE/vt.log | awk '{print $2}' | grep -v "^$" | wc -l)"
TVT="$(cat $WORKINGDIR/$RUNSAMPLE/vt.log | wc -l)"


# Reset Vendor_ID

VENDOR_ID="1"
VT_FOUND="0"


for a in $SELECTED_AV; do
        NAME="$(cat $WORKINGDIR/$RUNSAMPLE/vt.log | grep $a | head -1 | awk '{print $2 $3 $4 $5 $6 $7 $8}')"
        if [ "$NAME" == "Trojan" ] || [ "$NAME" == "Suspiciousfile" ] || [ "$NAME" == "Riskware" ] || [ "$NAME" == "Virus" ]; then
                NAME="Heuristic.gen"
        fi
        
        
        if [ ! -z $NAME ]; then
            echo "INSERT INTO scaninfo (xid, antivirus_company, name) VALUES ('$XID','$VENDOR_ID','$NAME');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
        	VT_FOUND="$(($VT_FOUND+1))"
		fi
        
        VENDOR_ID="$(($VENDOR_ID+1))"
done

if [ $VT_FOUND -le 3 ]; then
	VT_SCORE="4"
fi

if [ $VT_FOUND -ge 4 ] && [ $VT_FOUND -le 10 ]; then
	VT_SCORE="10"
fi

if [ $VT_FOUND -ge 11 ] && [ $VT_FOUND -le 25 ]; then
	VT_SCORE="20"
fi

if [ $VT_FOUND -ge 26 ]; then
	VT_SCORE="30"
fi

# bin-test, service from shadowserver.org

BINTEST="$(curl --connect-timeout 2 -s http://bin-test.shadowserver.org/api?md5=$RUNSAMPLEMD5 | awk -F \{ '{print $2}' | awk -F \} '{print $1}' | sed -e 's/\"//g')"

if [ -z $BINTEST];then
	printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
	echo "<blockquote><strong>#-- Bin-Test Check (shadowserver.org): --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt
	printf "Record Not Found" >> $WORKINGDIR/$RUNSAMPLE/report.txt
	REP="$(($REP+5))"
else
	echo $BINTEST > $WORKINGDIR/$RUNSAMPLE/bintest.log
	printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
	echo "<blockquote><strong>#-- Bin-Test Check (shadowserver.org): --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt
	echo $BINTEST | awk -F \, '{print " "$1"\n"$2"\n"$4"\n"$5"\n"$13}' >> $WORKINGDIR/$RUNSAMPLE/report.txt
	echo $BINTEST | awk -F \, '{print " "$1"\n"$2"\n"$4"\n"$5"\n"$13}' > $WORKINGDIR/$RUNSAMPLE/bint.log

    BT_SCORE="-15"

    BINSOURCE="$(cat $WORKINGDIR/$RUNSAMPLE/bint.log | grep source: | awk '{print $2}' | tr -d "'")"
    BINFILE="$(cat $WORKINGDIR/$RUNSAMPLE/bint.log | grep filename: | awk '{print $2}' | tr -d "'")"
    BINPRO="$(cat $WORKINGDIR/$RUNSAMPLE/bint.log | grep product_name: | awk '{print $2}' | tr -d "'")"
    BINMFG="$(cat $WORKINGDIR/$RUNSAMPLE/bint.log | grep mfg_name: | awk '{print $2}' | tr -d "'")"

	echo \
	"INSERT INTO whitelist (xid, source, original_filename, manufacturer_name, product_name) \
	VALUES ('$XID','$BINSOURCE','$BINFILE','$BINMFG','$BINPRO');"	>> $WORKINGDIR/$RUNSAMPLE/xandora.sql
fi


# Report for Files

printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
echo "<blockquote><strong>#-- Files Created: --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt
cat $WORKINGDIR/$RUNSAMPLE/sgeneratedfiles.txt | grep -v "SoftwareDistribution" |grep -v "workspace" | grep -v "TASKLIST.EXE" >> $WORKINGDIR/$RUNSAMPLE/report.txt

FILECOUNT="$(cat $WORKINGDIR/$RUNSAMPLE/sgeneratedfiles.txt | grep -v "workspace" | grep -v "TASKLIST.EXE" | wc -l)"
FILECOUNT="$(($FILECOUNT+5))"
REP="$(($REP+$FILECOUNT))"

# Report for Registry

printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
echo "<blockquote><strong>#-- Registry Created: --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt

echo "SOFTWAREregistries add"
insertregadd $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-post.txt 1 $XID
echo "SOFTWAREregistries del"
insertregdel $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-post.txt 1 $XID

echo "SYSTEMregistries add"
insertregadd $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-post.txt 2 $XID
echo "SYSTEMregistries del"
insertregdel $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-post.txt 2 $XID

echo "SECURITIESregistries add"
insertregadd $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-post.txt 3 $XID
echo "SECURITIESregistries del"
insertregdel $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-post.txt 3 $XID

echo "DEFAULTregistries add"
insertregadd $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-post.txt 4 $XID
echo "DEFAULTregistries del"
insertregdel $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-post.txt 4 $XID

echo "NTUSERregistries add"
insertregadd $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-post.txt 5 $XID
echo "NTUSERregistries del"
insertregdel $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-post.txt 5 $XID

echo "SAMregistries add"
insertregadd $WORKINGDIR/$RUNSAMPLE/SAMregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SAMregistries-post.txt 6 $XID
echo "SAMregistries del"
insertregdel $WORKINGDIR/$RUNSAMPLE/SAMregistries-pre.txt $WORKINGDIR/$RUNSAMPLE/SAMregistries-post.txt 6 $XID

#
# -- Report for Process --
#

echo "System Processes List for report.txt" >> $BASEDIR/logs/process.log
printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
echo "<blockquote><strong>#-- Running Processes: --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt

#python $BASEDIR/volatility/volatility pslist -f $WORKINGDIR/$RUNSAMPLE/memoryimage.dump >> $WORKINGDIR/$RUNSAMPLE/report.txt  > $WORKINGDIR/$RUNSAMPLE/pslist.rpt
cat $WORKINGDIR/$RUNSAMPLE/pslist.rpt | grep -v 'Jan 01 00:00:00 1970' | awk '{print "<b>"$1"</b> PID:"$2 " PPID:"$3 }' | grep -v 'PPID:PPid' >> $WORKINGDIR/$RUNSAMPLE/report.txt
PID="$(cat $WORKINGDIR/$RUNSAMPLE/pslist.rpt | grep -v 'Jan 01 00:00:00 1970' | awk '{print $2}' | grep -v ' PPID:PPid' | grep -v 'Pid')"


for a in $PID; do
	SPNAME="$(cat $WORKINGDIR/$RUNSAMPLE/pslist.rpt | grep -v 'Jan 01 00:00:00 1970' | awk '{print $1":"$2}' | grep -v ' PPID:PPid' | grep -v 'Pid' | grep $a | awk -F : '{print $1}' | tr -d "'" | strings)"
	SPID="$a"
	#SPPID="$(cat $WORKINGDIR/$RUNSAMPLE/pslist.rpt | grep -v 'Jan 01 00:00:00 1970' | awk '{print $3}' | grep -v ' PPID:PPid' | grep -v 'Pid' | grep $a | strings)"
	echo \
	"INSERT INTO processinfo (xid, pid, ppid, process_name) VALUES ('$XID','$SPID','$SPPID','$SPNAME');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql	
done

#
# -- All OutGoing Connections --
#

printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
echo "<blockquote><strong>#-- Malware Traffic - Connections: --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt
sudo tcpdump -lnnr $WORKINGDIR/$RUNSAMPLE/trafficdump.pcap dst net not 192.168.0.0/16 and dst net not 202.190.74.0/24 and not port 123 and not port 80 \
| grep -v "IP6" | grep -v "239.255.255.250.1900" | grep -v "224.0.0.22" | awk -F \> '{print $2}' | awk -F: '{print $1}' | sort | uniq | head -10 >> $WORKINGDIR/$RUNSAMPLE/report.txt

#
# -- SQL Traffic Connections --
#

TRAFFICCON="$(sudo tcpdump -lnnr $WORKINGDIR/$RUNSAMPLE/trafficdump.pcap \
        dst net not 192.168.0.0/16 and not host 239.255.255.250 and not icmp and not igmp \
        and not host 8.8.8.8 and not host 192.228.128.18 and not host 127.0.0.1 and not port 1900 and not port 123 and not port 80 \
        | grep -v "IP6" | awk -F ">" '{print $2}' | awk -F ":" '{print $1}' | sort | uniq)"

for TRCON in $TRAFFICCON ; do

        TRHOST="$(echo $TRCON | awk -F'.' '{print $1"."$2"."$3"."$4}')"
        TRPORT="$(echo $TRCON | awk -F'.' '{print $5}')"
        GEOIP="$(geoiplookup $TRHOST | awk -F , {'print $1'} | awk {'print $4'})"
        if [ ! -z $TRPORT ]; then
				REP="$(($REP+2))"
                echo \
                        "INSERT INTO trafficinfo VALUES ('','$TRHOST','','','','$TRPORT','','$GEOIP','$XID');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
        fi

done

#
# -- Web Traiffic --
#

printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
echo "<blockquote><strong>#-- Malware Traffic - www: --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt
chown $USER:$GROUP $WORKINGDIR/$RUNSAMPLE/report.txt
sudo su $USER - -c "tshark -r $WORKINGDIR/$RUNSAMPLE/trafficdump.pcap -R http.request -T fields -e http.host -e http.request.uri" >> $WORKINGDIR/$RUNSAMPLE/webtraffic.log

#
# -- SQL trafficwww --
#

cat $WORKINGDIR/$RUNSAMPLE/webtraffic.log | grep -v "239.255.255.250:1900" > $WORKINGDIR/$RUNSAMPLE/webtraffic_new.log
rm $WORKINGDIR/$RUNSAMPLE/webtraffic.log 
mv $WORKINGDIR/$RUNSAMPLE/webtraffic_new.log $WORKINGDIR/$RUNSAMPLE/webtraffic.log 

trafficwwwRECO="$(cat $WORKINGDIR/$RUNSAMPLE/webtraffic.log | awk '{print "<strong>"$1"</strong>"$2}')"

www_host="$(cat $WORKINGDIR/$RUNSAMPLE/webtraffic.log | awk '{print $1}')"
www_url="$(cat $WORKINGDIR/$RUNSAMPLE/webtraffic.log | awk '{print $1"___"$2}')"

for u in $www_url ; do
	wwwd="$(echo $u | awk -F ___ '{print $1}')"
	wwwip="$(host $wwwd | grep address | grep has | grep -v alias | head -1 | awk '{print $4}')"
	www="$(echo "$u" | awk -F ___ '{print $1 $2}')"
	GEOIP="$(geoiplookup $wwwip | awk -F , {'print $1'} | awk {'print $4'})"
	
	if [ -z $wwwip ]; then
		wwwip="0.0.0.0"
	else
		REP="$(($REP+3))"
		echo "INSERT INTO trafficinfo VALUES ('','$wwwip','','$wwwd','$www','80','','$GEOIP','$XID');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql		
	fi

done




#
# Clean the Image, this is bad code 
#

cd $WORKINGDIR/$RUNSAMPLE

printf "\n\n" >> $WORKINGDIR/$RUNSAMPLE/report.txt
echo "<blockquote><strong>#-- Screenshots: --</strong></blockquote>" >> $WORKINGDIR/$RUNSAMPLE/report.txt

IMAGE1MD5="$(md5sum screen01.jpg | awk '{print $1}')"
IMAGE2MD5="$(md5sum screen02.jpg | awk '{print $1}')"
IMAGE3MD5="$(md5sum screen03.jpg | awk '{print $1}')"
IMAGE4MD5="$(md5sum screen04.jpg | awk '{print $1}')"

for b in $IMGERR; do
        if [ "$IMAGE1MD5" == "$b" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen01.jpg ]; then
              REP="$(($REP+3))"
                rm $WORKINGDIR/$RUNSAMPLE/screen01.jpg
        fi
        
		if [ "$IMAGE2MD5" == "$b" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen02.jpg ]; then
            REP="$(($REP+3))"
                rm $WORKINGDIR/$RUNSAMPLE/screen02.jpg
                fi
        
        if [ "$IMAGE3MD5" == "$b" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen03.jpg ]; then
            REP="$(($REP+3))"
                        rm $WORKINGDIR/$RUNSAMPLE/screen03.jpg
                fi
        
        if [ "$IMAGE4MD5" == "$b" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen04.jpg ]; then
                REP="$(($REP+3))"
                                rm $WORKINGDIR/$RUNSAMPLE/screen04.jpg
                fi
done



for c in $IMGEMPTY; do
        if [ "$IMAGE1MD5" == "$c" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen01.jpg ]; then
                REP="$(($REP+5))"
                rm $WORKINGDIR/$RUNSAMPLE/screen01.jpg
        fi

        if [ "$IMAGE2MD5" == "$c" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen02.jpg ]; then
                REP="$(($REP+5))"
                rm $WORKINGDIR/$RUNSAMPLE/screen02.jpg
        fi

        if [ "$IMAGE3MD5" == "$c" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen03.jpg ]; then
                REP="$(($REP+5))"
                rm $WORKINGDIR/$RUNSAMPLE/screen03.jpg
        fi

        if [ "$IMAGE4MD5" == "$c" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen04.jpg ]; then
                REP="$(($REP+5))"
                rm $WORKINGDIR/$RUNSAMPLE/screen04.jpg
        fi
done



for d in $IMGDLL; do
        if [ "$IMAGE1MD5" == "$d" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen01.jpg ]; then
                REP="$(($REP+1))"
                rm $WORKINGDIR/$RUNSAMPLE/screen01.jpg
        fi
        if [ "$IMAGE2MD5" == "$d" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen02.jpg ]; then
                REP="$(($REP+1))"
                rm $WORKINGDIR/$RUNSAMPLE/screen02.jpg
        fi

        if [ "$IMAGE3MD5" == "$d" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen03.jpg ]; then
                REP="$(($REP+1))"
                rm $WORKINGDIR/$RUNSAMPLE/screen03.jpg
        fi

        if [ "$IMAGE4MD5" == "$d" ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen04.jpg ]; then
                REP="$(($REP+1))"
                rm $WORKINGDIR/$RUNSAMPLE/screen04.jpg
        fi
done


        
if [ $IMAGE1MD5 = $IMAGE2MD5 ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen02.jpg ]; then
        rm $WORKINGDIR/$RUNSAMPLE/screen02.jpg
fi

if [ $IMAGE2MD5 = $IMAGE3MD5 ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen03.jpg ]; then
        rm $WORKINGDIR/$RUNSAMPLE/screen03.jpg
fi

if [ $IMAGE3MD5 = $IMAGE4MD5 ] && [ -f $WORKINGDIR/$RUNSAMPLE/screen04.jpg ]; then
        rm $WORKINGDIR/$RUNSAMPLE/screen04.jpg
fi

for a in $TOTALIMG ; do
	s3uploadsc $a
done


cd $WORKINGDIR/$RUNSAMPLE

if [ "$DUMPEXE" == "1" ] ; then
                cd $WORKINGDIR/$RUNSAMPLE/mnt_changes
                FILE="$(find . -type f -exec file {} \; | grep executable | awk -F : '{print $1}')"
                TOTALCP="0"

                for FILEEXEC in $FILE; do 
                        if [ $TOTALCP -lt 2 ]; then
                                cp $FILEEXEC $BASEDIR/newfiles/sample$(date +%N).$RUNSAMPLEMD5
                                REP="$(($REP+5))"
                                TOTALCP="$(($TOTALCP+1))"
                        fi
                done
fi

cd $WORKINGDIR/$RUNSAMPLE
7za a -pinfected $RUNSAMPLE.zip $RUNSAMPLE
#s3cmd -c $BASEDIR/conf/s3.cfg --acl-public put $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.zip s3://xandora/samples/$RUNSAMPLE.zip
cd -

for a in $SHARESAMPLE ; do
	
	E_OWNER="$($SQLCRESINGLE_E "select id from users where email='$a';")"

	if [ "$REP" -gt "$BADREP" ] && [ -z $BINTESTY ] && [ "$E_OWNER" != "$FUID" ]; then
        	( /usr/bin/printf "Dear All,"\
        	; /usr/bin/printf "\n\xandora Report: http://www.xandora.net/xangui/malware/view/$RUNSAMPLEMD5" \
        	; /usr/bin/printf "\n\n" \
        	; /usr/bin/printf "Binary MD5: $RUNSAMPLEMD5 \n" \
        	; /usr/bin/printf "Password: Infected\n" \
        	; /usr/bin/printf "We need malware samples, please contact: feedback@xandora.net\n" \
        	; /usr/bin/printf "$DISCLAIMER" \
        	; /usr/bin/printf "\n\n" \
        	; echo "$(uuencode $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.zip $RUNSAMPLE.zip)" \
        	; /usr/bin/printf "\n\n-----\n xandora team" ) \
        	| mail -a "From: xandora.net <$SMAILFROM>" -s "Malware sample: $RUNSAMPLEMD5" $a
			
			echo "INSERT INTO sharing VALUES ('','$XID','$E_OWNER');" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
			
	fi

done

#
# Scoring
# 

REP="$(($VT_SCORE+$BT_SCORE+$REP))"

if [ $REP -lt 1 ]; then
        REP="5"
fi


#
# insert into database
#

echo "update malwareinfo set score='$REP' where xid='$XID';" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "update malwareinfo set status='Done' where xid='$XID';" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "update malwareinfo set cdate='$DATE' where xid='$XID';" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "update malwareinfo set ctime='$TIME' where xid='$XID';" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "update malwareinfo set mdate='$DATE' where xid='$XID';" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "update malwareinfo set mtime='$TIME' where xid='$XID';" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "UPDATE stat_counter SET totalrec = totalrec + 1;" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "UPDATE stat_counter SET totaltoday = totaltoday + 1;" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "UPDATE stat_counter SET totalweek = totalweek + 1;" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql
echo "UPDATE stat_counter SET totalmonth = totalmonth + 1;" >> $WORKINGDIR/$RUNSAMPLE/xandora.sql

$SQL_E < $WORKINGDIR/$RUNSAMPLE/xandora.sql

STATUS="$($SQLCRESINGLE_E "select status from malwareinfo where xid='$XID'")"

if [ "$STATUS" != "Done" ]; then
	$SQLCRE_E "update malwareinfo set status='Done' where xid='$XID';"
fi

#
# For Panda
#



#
# -- Final Process / Clean Up --
#

cd $WORKINGDIR

rm -rf $WORKINGDIR/$RUNSAMPLE/mnt_changes/sample.$EXT
rm -rf $WORKINGDIR/$RUNSAMPLE/mnt_changes/NETWORK.BAT
rm -rf $WORKINGDIR/$RUNSAMPLE/mnt_changes/RUNME.BAT
rm -rf $WORKINGDIR/$RUNSAMPLE/mnt_changes/run.bat
rm -rf $WORKINGDIR/$RUNSAMPLE/SOFTWAREregistries-pre.txt
rm -rf $WORKINGDIR/$RUNSAMPLE/SYSTEMregistries-pre.txt
rm -rf $WORKINGDIR/$RUNSAMPLE/SECURITIESregistries-pre.txt
rm -rf $WORKINGDIR/$RUNSAMPLE/SAMregistries-pre.txt
rm -rf $WORKINGDIR/$RUNSAMPLE/DEFAULTregistries-pre.txt
rm -rf $WORKINGDIR/$RUNSAMPLE/NTUSERregistries-pre.txt
rm -rf $WORKINGDIR/$RUNSAMPLE/workiso
rm -rf $WORKINGDIR/$RUNSAMPLE/*.lock
rm -rf $WORKINGDIR/$RUNSAMPLE/*.log
rm -rf $WORKINGDIR/$RUNSAMPLE/report*
rm -rf $WORKINGDIR/$RUNSAMPLE/sandbox.qcow2
rm -rf $WORKINGDIR/$RUNSAMPLE/xandora.iso

if [ ! -d $STORAGE/samples/$DATE ]; then
	mkdir $STORAGE/samples/$DATE
fi

if [ ! -d $STORAGE/processed/$DATE ]; then
	mkdir $STORAGE/processed/$DATE
fi

cp $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.zip $STORAGE/samples/$DATE

cd $WORKINGDIR
tar cfj $RUNSAMPLE.tar.bz2 $RUNSAMPLE
mv $WORKINGDIR/$RUNSAMPLE.tar.bz2 $STORAGE/processed/$DATE
rm -rf $WORKINGDIR/$RUNSAMPLE
rm $BASEDIR/logs/qemu-$QDEV.lock
cd -

cd $BASEDIR
