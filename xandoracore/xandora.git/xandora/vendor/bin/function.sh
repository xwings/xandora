## Library
export BASEDIR="/opt/malwareader"
source $BASEDIR/bin/settings.sh

DATE="$(date +%F)"
TIME="$(date +%R)"

function renamefiles () {
	
	
	if [ -d $DOWNLOADPATH ]; then
		cd $DOWNLOADPATH
		find * -print0 | while read -d $'\0' file; do
	        mv $file samples`date +%N`
		done
		ls -alF
	fi
	
	MDBX="$(ls $DOWNLOADPATH )"

	if [ ! -z "${MDBX[0]}" ]; then
		for a in $MDBX ; do
			
			SHASUM="$(sha512sum $DOWNLOADPATH/$a | awk '{print $1}')"
			EXITS="$($SQLCRESINGLE "select sha512 from malwareinfo where sha512='$SHASUM' limit 1" | head -1 | awk '{print $1}')"

			if [ -z $FUID ]; then
				FUID="$(echo $a | awk -F \. '{print $2}')"
			fi

			if [ -z $FUID ]; then
				FUID="21"
			fi
			

			FILETYPE="$(file $DOWNLOADPATH/$a | grep DLL)"
			if [ ! -d $BASEDIR/found/$SHASUM ] && [ -f $DOWNLOADPATH/$a ] && [ ! -z "$FILETYPE" ] && [ -z $EXITS ]; then
					
					SHASUM="$(sha512sum $DOWNLOADPATH/$a | awk '{print $1}')"
					RUNSAMPLEMD5="$(md5sum $DOWNLOADPATH/$a | awk '{print $1}')"
					RUNSAMPLESHA1="$(sha1sum $DOWNLOADPATH/$a | awk '{print $1}')"
					RUNSAMPLESHA512="$(sha512sum $DOWNLOADPATH/$a | awk '{print $1}')"
					FILESIZE="$(du -b $DOWNLOADPATH/$a | awk '{print $1}')"

					mkdir $BASEDIR/found/$SHASUM
					
					echo "FUID: $FUID" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					printf "\n" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					echo "Filetype: dll" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					printf "\n\n" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					python $BASEDIR/pefile/pedllscanner.py $DOWNLOADPATH/$a > $BASEDIR/found/$SHASUM/$SHASUM.dllinfo & sleep 5 ; kill $!
					
					echo "@echo off" > $BASEDIR/found/$SHASUM/rundllf.bat
					echo "cmd /c start /min c:\windows\system32\rundll32.exe c:\workspace\sample.dll" >> $BASEDIR/found/$SHASUM/rundllf.bat

					FDUMP="$(cat $BASEDIR/found/$SHASUM/$SHASUM.dllinfo)"
					
					for f in $FDUMP; do
						echo "cmd /c start /min c:\windows\system32\rundll32.exe c:\workspace\sample.dll,$f" >> $BASEDIR/found/$SHASUM/rundllf.bat
					done
					
					mv $DOWNLOADPATH/$a $BASEDIR/found/$SHASUM/$SHASUM
					
				CHECKSUM="$(sha512sum $BASEDIR/found/$SHASUM/$SHASUM | awk '{print $1}')"

				if [ "$CHECKSUM" == "$SHASUM" ]; then   

					$SQLCRE \
						"INSERT INTO malwareinfo  (sha512, sha1, md5, cdate, ctime, mdate, mtime, score, filesize, ext, status) \
						VALUES ('$RUNSAMPLESHA512','$RUNSAMPLESHA1','$RUNSAMPLEMD5','$DATE','$TIME','$DATE','$TIME','0','$FILESIZE','2', 'Queue');"

						## Inset FUID
						XID="$($SQLCRESINGLE "select xid from malwareinfo where md5='$RUNSAMPLEMD5' limit 1" | awk '{print $1}')"
						$SQLCRE "INSERT INTO fileuid (xid, user_id) VALUES ('$XID','$FUID');"

						echo "XID: $XID" >> $BASEDIR/found/$SHASUM/$SHASUM.info
						touch $BASEDIR/found/$SHASUM/vendor.log
				fi
			fi

			FILETYPE="$(file $DOWNLOADPATH/$a | grep executable | grep -v DLL)"
			if [ ! -d $BASEDIR/found/$SHASUM ] && [ -f $DOWNLOADPATH/$a ] && [ ! -z "$FILETYPE" ] && [ -z $EXITS ]; then

					SHASUM="$(sha512sum $DOWNLOADPATH/$a | awk '{print $1}')"
					RUNSAMPLEMD5="$(md5sum $DOWNLOADPATH/$a | awk '{print $1}')"
					RUNSAMPLESHA1="$(sha1sum $DOWNLOADPATH/$a | awk '{print $1}')"
					RUNSAMPLESHA512="$(sha512sum $DOWNLOADPATH/$a | awk '{print $1}')"                                       
					FILESIZE="$(du -b $DOWNLOADPATH/$a | awk '{print $1}')"

					mkdir $BASEDIR/found/$SHASUM
					echo "FUID: $FUID" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					printf "\n" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					echo "Filetype: exe" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					printf "\n\n" >> $BASEDIR/found/$SHASUM/$SHASUM.info
					mv $DOWNLOADPATH/$a $BASEDIR/found/$SHASUM/$SHASUM
					  

					CHECKSUM="$(sha512sum $BASEDIR/found/$SHASUM/$SHASUM | awk '{print $1}')"

					if [ "$CHECKSUM" == "$SHASUM" ]; then   
						$SQLCRE \
							"INSERT INTO malwareinfo  (sha512, sha1, md5, cdate, ctime, mdate, mtime, score, filesize, ext, status) \
							VALUES ('$RUNSAMPLESHA512','$RUNSAMPLESHA1','$RUNSAMPLEMD5','$DATE','$TIME','$DATE','$TIME','0','$FILESIZE','1', 'Queue');"

							## Inset FUID
							XID="$($SQLCRESINGLE "select xid from malwareinfo where md5='$RUNSAMPLEMD5' limit 1" | awk '{print $1}')"
							$SQLCRE "INSERT INTO fileuid (xid, user_id) VALUES ('$XID','$FUID');"
						
							echo "XID: $XID" >> $BASEDIR/found/$SHASUM/$SHASUM.info
							touch $BASEDIR/found/$SHASUM/vendor.log
					fi
			fi

			if [ -f $DOWNLOADPATH/$a ]; then
			
				SHASUM="$(sha512sum $DOWNLOADPATH/$a | awk '{print $1}')"
				MD5SUM="$(md5sum $DOWNLOADPATH/$a | awk '{print $1}')"

				rm $DOWNLOADPATH/$a				
				XID="$($SQLCRESINGLE "select xid from malwareinfo where sha512='$SHASUM' limit 1" | head -1 | awk '{ print $1 }')"
				if [ ! -z $XID ]; then
					$SQLCRE "INSERT INTO appearance (xid, mdate, mtime, user_id) VALUES ('$XID','$DATE','$TIME','$FUID');"
				fi
			fi

			cd $BASEDIR
		done
	fi
	cd -
}
