#!/bin/sh

if [ "$1" == "update" ]; then

	cd /home/xwings/xandora

	sudo cp -r bin /opt/malwareader

	rm -rf /home/xwings/xandora/bin/*

elif [ "$1" == "settings" ]; then
	
	cd /home/xwings/xandora

	sudo cp -r bin/settings.sh /opt/malwareader/settings.sh

	rm -rf /home/xwings/xandora/bin/*
fi