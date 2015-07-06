#!/bin/bash
if [ "$(id -u abc)" != "$PUID" ]; then usermod -o -u  "$PUID" abc ; fi
if [ "$(id -g abc)" != "$PGID" ]; then groupmod -o -g  "$PGID" abc ; fi


echo "
-----------------------------------
GID/UID
-----------------------------------
User uid:    $(id -u abc)
User gid:    $(id -g abc)
-----------------------------------
"