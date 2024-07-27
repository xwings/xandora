#!/bin/sh

## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh
source $BASEDIR/bin/function.sh

## Local Var
RUNSAMPLE="$1"
FILETYPE="$2"
EXT="$FILETYPE"
WORKINGDIR="$BASEDIR/working"

SID="$3"
SANID="$3"


QID="Q1_$SID"
QINT="qemu-ifup$SID"

MID=$((20+$SID))
MACADD="52:54:00:11:11:$MID"

if [ $SID -lt 10 ]; then
	IP=$((100+$SID))
	INT="tap$SID"
	PMEM="44$SID$SID"
	VNCPORT="$SID"
fi

if [ $SID -gt 9 ]; then
	SID=$((20+$SID))
	IP=$((100+$SID))
	INT="tap$SID"
	PMEM="45$SID"
	VNCPORT="$SID"
fi

## Checking and initializing
getinfo

#$SQLCRE_E \
#        "INSERT INTO malwareinfo  (sha512, sha1, md5, cdate, ctime, mdate, mtime, score, filesize, ext, status) \
#		VALUES ('$RUNSAMPLESHA512','$RUNSAMPLESHA1','$RUNSAMPLEMD5','$DATE','$TIME','$DATE','$TIME','0','$FILESIZE','$EXTDB', 'Ready');"

getxidremote
$SQLCRE_E "update malwareinfo set status='Ready' where xid='$XID';"



# Preparation
cd $WORKINGDIR/$RUNSAMPLE
mkdir $WORKINGDIR/$RUNSAMPLE/workiso
touch $WORKINGDIR/$RUNSAMPLE/workiso/network.bat
echo "@echo off" > $WORKINGDIR/$RUNSAMPLE/workiso/network.bat
echo "netsh interface ip set address \"Local Area Connection\" static 192.168.$IP.100 255.255.255.0 192.168.$IP.1 1" >> $WORKINGDIR/$RUNSAMPLE/workiso/network.bat
echo "netsh interface ip set dns \"Local Area Connection\" static 8.8.8.8" >> $WORKINGDIR/$RUNSAMPLE/workiso/network.bat
#echo "ipconfig /all > c:\workspace\network.log" >> $WORKINGDIR/$RUNSAMPLE/workiso/network.bat
#echo "ping -t 192.228.128.18" >> $WORKINGDIR/$RUNSAMPLE/workiso/network.bat
echo "exit" >> $WORKINGDIR/$RUNSAMPLE/workiso/network.bat

if [ -f $WORKINGDIR/$RUNSAMPLE/rundllf.bat ]; then
        cp $WORKINGDIR/$RUNSAMPLE/rundllf.bat $WORKINGDIR/$RUNSAMPLE/workiso/rundllf.bat
fi

cp $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE $WORKINGDIR/$RUNSAMPLE/workiso/sample.$EXT
cp $BASEDIR/conf/run$EXT.bat $WORKINGDIR/$RUNSAMPLE/workiso/runme.bat
cp $BASEDIR/conf/autorun.inf $WORKINGDIR/$RUNSAMPLE/workiso/autorun.inf

mkisofs  -r -o xandora.iso workiso

qemu-img create -b $BASEDIR/vms/winxp.qcow2 -f qcow2 $WORKINGDIR/$RUNSAMPLE/sandbox.qcow2

# -- Start QEMU, with screen capture --

sudo tunctl -u root -d $INT
touch $WORKINGDIR/$RUNSAMPLE/$RUNSAMPLE.memdump

#Create 
echo "#!/bin/bash" > $BINARIES/qemu-ifup$SID
echo "sudo /sbin/ifconfig tap$SID 192.168.$IP.1" >> $BINARIES/qemu-ifup$SID
echo "echo \"1\" > /proc/sys/net/ipv4/ip_forward" >> $BINARIES/qemu-ifup$SID
chmod 755 $BINARIES/qemu-ifup$SID

sudo qemu -m 256 -localtime -net nic,macaddr=$MACADD -net tap,ifname=$INT,script=$BINARIES/qemu-ifup$SID \
-hda $WORKINGDIR/$RUNSAMPLE/sandbox.qcow2 -cdrom xandora.iso \
-vnc 127.0.0.1:$VNCPORT -serial mon:telnet:127.0.0.1:$PMEM,server,nowait &

sleep $INITIALWAIT

echo "Starting tcpdump"
sudo tcpdump -w $WORKINGDIR/$RUNSAMPLE/trafficdump.pcap -s0 -xX -lnni $INT &
(sleep 2;printf '\x01'; printf 'c'; printf "\r\n") | telnet 127.0.0.1 $PMEM
sleep $(($WAIT/5))


vncsnapshot 127.0.0.1:$VNCPORT $WORKINGDIR/$RUNSAMPLE/screen01.jpg &
(sleep 2; printf 'sendkey enter'; printf "\r\n") | telnet 127.0.0.1 $PMEM
sleep $(($WAIT/5))


vncsnapshot 127.0.0.1:$VNCPORT $WORKINGDIR/$RUNSAMPLE/screen02.jpg &
(sleep 2; printf 'sendkey enter'; printf "\r\n") | telnet 127.0.0.1 $PMEM
sleep $(($WAIT/5))

vncsnapshot 127.0.0.1:$VNCPORT $WORKINGDIR/$RUNSAMPLE/screen03.jpg &
(sleep 2; printf 'sendkey enter'; printf "\r\n") | telnet 127.0.0.1 $PMEM
sleep $(($WAIT/5))

(sleep 2;printf 'pmemsave 0 268435456 memoryimage.dump'; printf "\r\n") | telnet 127.0.0.1 $PMEM

sleep $(($WAIT/5))
vncsnapshot 127.0.0.1:$VNCPORT $WORKINGDIR/$RUNSAMPLE/screen04.jpg &

(sleep 5; printf 'sendkey alt-f4'; printf "\r\n") | telnet 127.0.0.1 $PMEM
(sleep 5; printf 'sendkey u'; printf "\r\n"; sleep 2; printf 'sendkey enter'; printf "\r\n" ;sleep 10) | telnet 127.0.0.1 $PMEM


KILLQEMU="$(ps aux | grep qemu | grep $RUNSAMPLE | awk '{print $2}')"
KILLDUMP="$(ps aux | grep tcpdump | grep $RUNSAMPLE | awk '{print $2}')"

sudo kill -9 $KILLQEMU
sudo kill -9 $KILLDUMP
unset KILLDUMP KILLQEMU
sleep 3


KILLVNC="$(ps aux | grep vncsnapshot | grep $RUNSAMPLE | awk '{print $2}')"
if [ ! -z "$KILLVNC" ]; then
        killall -9 vncsnapshot
fi

if [ -f $BASEDIR/logs/dynamicdump$SANID.lock ]; then
        rm -rf $BASEDIR/logs/dynamicdump$SANID.lock
fi

if [ -f $BINARIES/qemu-ifup$SID ]; then
        rm -rf $BINARIES/qemu-ifup$SID
fi


#
# memoryimage.dump
#

python $BASEDIR/volatility/volatility pslist -f $WORKINGDIR/$RUNSAMPLE/memoryimage.dump >> $WORKINGDIR/$RUNSAMPLE/report.txt  > $WORKINGDIR/$RUNSAMPLE/pslist.rpt
strings $WORKINGDIR/$RUNSAMPLE/memoryimage.dump >> $WORKINGDIR/$RUNSAMPLE/memoryimage.txt

rm $WORKINGDIR/$RUNSAMPLE/memoryimage.dump

#
# Moving files
#


sudo cp -aRp $WORKINGDIR/$RUNSAMPLE $BASEDIR/preport
if [ -d $BASEDIR/preport/$RUNSAMPLE ]; then
	rm -rf $WORKINGDIR/$RUNSAMPLE
fi
touch $BASEDIR/preport/$RUNSAMPLE/sandbox.lock



cd $BASEDIR
