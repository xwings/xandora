#!/bin/sh


DEVHOME="/Users/xwings/coding/xangui.git/xangui"
DEVHOME_CN="/Users/xwings/coding/xangui.git/xangui_cn"
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
        scp -r $DEVHOME/frontpage $DEVHOME/cloudantivirus $DEVHOME/.htaccess $DEVHOME/favicon.ico $DEVHOME/application $DEVHOME/css $DEVHOME/images $DEVHOME/index.php $DEVHOME/js $DEVHOME/modules $DEVHOME/system xwings@a.xandora.net:~/xangui
        ssh a.xandora.net 'sudo /home/xwings/updatexangui.sh &'

       	if [ -d $DEVHOME_CN ]; then
			scp -r $DEVHOME_CN/frontpage $DEVHOME_CN/cloudantivirus $DEVHOME_CN/.htaccess $DEVHOME_CN/favicon.ico $DEVHOME_CN/application $DEVHOME_CN/css $DEVHOME_CN/images $DEVHOME_CN/index.php $DEVHOME_CN/js $DEVHOME_CN/modules $DEVHOME_CN/system xwings@a.xandora.net:~/xangui_cn
       		ssh xwings@a.xandora.net 'sudo sh /home/xwings/updatexangui_cn.sh &'
		fi
		
elif [ "$1" == "stage" ]; then
       scp -r $DEVHOME/frontpage $DEVHOME/cloudantivirus $DEVHOME/.htaccess $DEVHOME/favicon.ico $DEVHOME/application $DEVHOME/css $DEVHOME/images $DEVHOME/index.php $DEVHOME/js $DEVHOME/modules $DEVHOME/system xwings@t.xandora.net:~/xangui
       
       ssh t.xandora.net 'sudo sh /home/xwings/updatexangui.sh &'

elif [ "$1" == "stage2_cn" ]; then
       scp -r $DEVHOME_CN/frontpage $DEVHOME_CN/cloudantivirus $DEVHOME_CN/.htaccess $DEVHOME_CN/favicon.ico $DEVHOME_CN/application $DEVHOME_CN/css $DEVHOME_CN/images $DEVHOME_CN/index.php $DEVHOME_CN/js $DEVHOME_CN/modules $DEVHOME_CN/system xwings@t2.xandora.net:~/xangui_cn

       ssh xwings@t2.xandora.net 'sudo sh /home/xwings/updatexangui_cn.sh &'
else
        echo "Usage: update/commit/deploy"
fi
