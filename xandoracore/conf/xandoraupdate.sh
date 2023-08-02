#!/bin/sh


DEVHOME="/Users/xwings/coding/xandora.git/xandora"
COMMENTS="$2"

if [ ! -d $DEVHOME ]; then
        echo "Directory $DEVHOME not found"
        exit
fi

if [ ! -z $3 ]; then
        echo "Do not use space for comments"
fi

if [ "$1" == "update" ]; then
        cd $DEVHOME
        git pull origin master

elif [ "$1" == "commit" ]; then

        if [ -z $COMMENTS ]; then
                echo "Please enter comments. Usage"
                echo "$0 commit \"your_comments_with_under_\""
        else                
                cd $DEVHOME
                git add .
                git commit -m "$COMMENTS"
                git push origin master
        fi

elif [ "$1" == "deploy" ]; then
        
        if [ "$2" == "a" ]; then
				scp -r $DEVHOME/conf/update.sh xwings@a.xandora.net:~/
				
                scp -r $DEVHOME/bin xwings@a.xandora.net:~/xandora
                ssh a.xandora.net '/home/xwings/update.sh update &'
        
        elif [ "$2" == "sandbox" ]; then
	
				scp -r $DEVHOME/conf/update.sh xwings@b.xandora.net:~/
                scp -r $DEVHOME/bin xwings@b.xandora.net:~/xandora
                ssh b.xandora.net '/home/xwings/update.sh update &'

				scp -r $DEVHOME/conf/update.sh xwings@c.xandora.net:~/
                scp -r $DEVHOME/bin xwings@c.xandora.net:~/xandora
                ssh c.xandora.net '/home/xwings/update.sh update &'
				
				scp -r $DEVHOME/conf/update.sh xwings@d.xandora.net:~/
                scp -r $DEVHOME/bin xwings@d.xandora.net:~/xandora
                ssh d.xandora.net '/home/xwings/update.sh update &'

 	    elif [ "$2" == "e" ]; then
				
				scp -r $DEVHOME/conf/update.sh xwings@e.xandora.net:~/
				
                scp -r $DEVHOME/bin xwings@e.xandora.net:~/xandora
                ssh e.xandora.net '/home/xwings/update.sh update &'
			
	    elif [ "$2" == "devbox" ]; then

					scp -r -P 20022 $DEVHOME/conf/update.sh xwings@x.xandora.net:~/

	                scp -r -P 20022  $DEVHOME/bin xwings@x.xandora.net:~/xandora
	                ssh -p 20022 x.xandora.net '/home/xwings/update.sh update &'

		elif [ "$2" == "settings" ]; then
			
				scp -r $DEVHOME/bin/settings.sh xwings@a.xandora.net:~/xandora
				scp -r $DEVHOME/bin/settings.sh xwings@b.xandora.net:~/xandora
				scp -r $DEVHOME/bin/settings.sh xwings@c.xandora.net:~/xandora
				scp -r $DEVHOME/bin/settings.sh xwings@d.xandora.net:~/xandora
				scp -r $DEVHOME/bin/settings.sh xwings@e.xandora.net:~/xandora

				ssh a.xandora.net '/home/xwings/update.sh settings &'
				ssh b.xandora.net '/home/xwings/update.sh settings &'
                ssh c.xandora.net '/home/xwings/update.sh settings &'
				ssh d.xandora.net '/home/xwings/update.sh settings &'
				ssh e.xandora.net '/home/xwings/update.sh settings &'

	    else


	                echo "Usage: deploy <OPTION>"
	    fi

else
        echo "Usage: update/commit/deploy"
fi
