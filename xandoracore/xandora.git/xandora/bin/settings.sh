## settings.sh

## Xandora Var
export BASEDIR="/opt/malwareader"
BASEDIR="/opt/malwareader"
SAMPLEDIR="$BASEDIR/newsamples"
STORAGE="/home/xandora"
BINDIR=$BASEDIR"/bin"
BINARIES=$BASEDIR"/bin"
PATH="$BINDIR:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin"


REP="0"
INITIALWAIT="35"
WAIT="180"

DUMPEXE="0"

TOTALUSERS="rodrigo lexsi quickheal sonicwall clamav anubis cwsandbox ikarus"

SELECTED_AV="Kaspersky \
NOD32 \
Panda \
Avast5 \
Rising \
PCTools \
AhnLab \
Microsoft \
Jiangmin \
TrendMicro \
DrWeb \
Sophos \
BitDefender \
McAfee \
F-Secure \
CAT-QuickHeal \
TheHacker \
K7AntiVirus \
VirusBuster \
F-Prot \
Symantec \
Norman \
Avast \
eSafe \
ClamAV \
ViRobot \
Comodo \
VIPRE \
AntiVir \
Emsisoft \
eTrust-Vet \
Command \
Antiy-AVL \
SUPERAntiSpyware \
Prevx \
VBA32 \
Ikarus \
Fortinet \
AVG"

TOTALIMG="screen01 screen02 screen03 screen04"

IMGERR="
d8f26a8e6a9087961221b4d0a8b16fb7
"

IMGEMPTY="
1b98390a432928e9e2545505625a39e6
74a44dffde988157923a38b6f485f6fa
80ee44764ce5a80935eede87c7e4dd69
ed4a0befb583644216e4cf2b7486243f
1cc9855fa082adee262c1cab01ed6961
20eac7b906e27e1cdcf5868e828fecd7
151e67b9ee5dff050d656e080494bdfe
4d920379bc687ecd89fa9435a7861833
51b8fff946456eca233b0a053148155d
5652bee821ce0f4dd9b0ab718d438066
b1a06f20078444121290655139eeba80
b1fc96cb9bee56a6d1d7d757a037f77e
d8c1163f94edd8aaa3b939e8b996121b
ebc81c09a5f125607eab64477225880d
2a7e2c4b0828a8075ada9a4982a87b10
99eda282afa0d9860c221b1711d4ab47
5c7d8c40b7a95d90570500f376eccebe
d1dc79319bbe93570d46cf5114e23594
"

IMGDLL="
0f6bb7e8e5fead1943fd1086cdd8d620
78671572221e3237dd73d0eba03e2be4
ead6ff3f6577725a082659c113440d7b
"


USER="xwings"
GROUP="xwings"
BADBOY="100"
BADREP="10"

TOTALSERVER="ready_0 ready_1"

# Mail Owner
FEEDBACK="feedback@xandora.net"
MAILFROM="labs@xandora.net"
SHARESAMPLE="samples@ikarus.at
sendvirus+malwaredatabase@unfiltered.clamav.net
threat_samples@sonicwall.com
virussamples@pandasecurity.com
vx-samples-03@lexsi.com"
SHAREURL="urlsamples@pandasecurity.com
samples@adminus.net
melingm@gmail.com"
DISCLAIMER="\n This is an email from xandora.net. \n\n we need contribution. \n For more information please email to: $FEEDBACK"
#SHARESAMPLE="avsubmit@symantec.com,\
#malware-cruncher@sunbelt-software.com,\
#submit-malware@shadowserver.org,\
#detections@spybot.info,\
#infection@bullguard.com,\
#is360submit@iobit.com,\
#labs@fsb-antivirus.com,\
#labsubmit@sophos.com,\
#malware-cruncher@sunbelt-software.com,\
#malware@michaelboman.net,\
#malwaredatabase@submit.microsoft.com,\
#malwaresubmit@avlab.comodo.com,\
#research@lavasoft.com,\
#samples@ahnlab.com,\
#samples@csis.dk,\
#samples@emergingthreats.net,\
#sample@eset.com,\
#samples@alienvault.com ,\
#samples@ikarus.at,\
#samples@superantispyware.com,\
#endvirus+malwaredatabase@unfiltered.clamav.net,\
#submissions@webroot.com,\
#submit-malware@shadowserver.org,\
#submit@brts.barracuda.com,\
#submit@emsisoft.com,\
#threat_samples@sonicwall.com,\
#virus@avast.com,\
#virus@avg.com,\
#virus@avira.com,\
#virus_doctor@trendmicro.com,\
#virus_research@mcafee.com,\
#virus_submission@bitdefender.com,\
#viruslab@f-prot.com,\
#virussamples@pandasecurity.com,\
#virussamples@samples.virusbuster.hu,\
#vms@drweb.com,\
#vsamples@f-secure.com,\
#vx-samples-03@lexsi.com"


# AV Settings
PAVCL="/opt/pavcl/usr/bin/pavcl"
PANDAFULLSIG="/opt/pavcl/etc/panda/pavcl"
KAVCL="/opt/kavcl/opt/kaspersky/kav4fs/bin/kav4fs-kavscanner"
KAVCFG="/opt/kavcl/etc/opt/kaspersky/kav4fs.conf"
NODCL="/opt/eset/usr/sbin/esets_scan"
NODCFG="/opt/eset/etc/esets"

## DB Settings

DBSRV="192.168.168.100"
DBUSER="xandora"
DBPASSWD="xandora789"
DBNAME="xandora"


SQL="mysql -u $DBUSER -p$DBPASSWD -f $DBNAME"
SQLCRE="mysql -u $DBUSER -p$DBPASSWD $DBNAME -e"
SQLCRESINGLE="mysql -u $DBUSER -p$DBPASSWD $DBNAME -sN -e"


SQL_E="mysql -u $DBUSER -p$DBPASSWD -f -h $DBSRV $DBNAME"
SQLCRE_E="mysql -u $DBUSER -p$DBPASSWD -h $DBSRV  $DBNAME -e"
SQLCRESINGLE_E="mysql -u $DBUSER -p$DBPASSWD -h $DBSRV $DBNAME -sN -e"

