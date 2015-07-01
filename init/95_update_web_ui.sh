#!/bin/bash


if [ "$WEBUI" == "1" ]; then
	cd /config/webui
	git pull && npm update
fi
