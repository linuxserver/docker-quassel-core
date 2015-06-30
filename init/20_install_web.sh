#!/bin/bash

if [ "$WEBUI" == "1" ]; then
	cd /config
	if [ ! -f /config/quassel-webserver/app.js ]; then
		git clone https://github.com/magne4000/quassel-webserver.git
		cd quassel-webserver
		npm install --production
	
	fi
	if [ ! -f /config/quassel-webserver/settings-user.js ]; then
		cp -v /default/settings-user.js /config/quassel-webserver/settings-user.js
	fi
