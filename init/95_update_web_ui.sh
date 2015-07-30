#!/bin/bash


if [ "$WEBUI" == "1" ]; then
	mkdir -p /defaults
	mv /config/quassel-webserver/settings-user.js /defaults/settings-user.js
	cd /config/quassel-webserver
	git pull && npm update
	mv /defaults/settings-user.js /config/quassel-webserver/settings-user.js
fi
