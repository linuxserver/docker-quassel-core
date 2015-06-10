#!/bin/bash

if [ ! "$(id -u quasseluser)" -eq "$PUID" ]; then usermod -u "$PUID" quasseluser ; fi
if [ ! "$(id -g quasseluser)" -eq "$PGID" ]; then groupmod -o -g "$PGID" quasseluser ; fi

echo "
-----------------------------------
GID/UID
-----------------------------------
User uid:    $(id -u quasseluser)
User gid:    $(id -g quasseluser)
-----------------------------------
"