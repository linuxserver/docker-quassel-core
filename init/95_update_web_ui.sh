#!/bin/bash


if [ "$WEBUI" == "1" ]; then
	cd /config/quassel-webserver
	git pull && npm update
fi
