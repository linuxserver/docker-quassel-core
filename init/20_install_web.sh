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
	if [ ! -f /etc/service/webui/run ]; then
		cat <<'EOT' > /etc/service/webui/run
			#!/bin/bash

			exec /sbin/setuser abc node /config/quassel-webserver/app.js -m http -p 64443
EOT
fi
else
	rm -fr /etc/service/webui 
fi