![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](http://linuxserver.io) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](http://forum.linuxserver.io) or for real-time support our [IRC](http://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/quassel-core

[Quassel IRC](http://quassel-irc.org/) is a modern, cross-platform, distributed IRC client, meaning that one (or multiple) client(s) can attach to and detach from a central core.

This container handles the IRC connection (quasselcore) and requires a desktop client (quasselclient) to be used and configured. It is designed to always on and will keep you present in IRC even when your clients cannot be online. 

![](http://bugs.quassel-irc.org/attachments/download/111/distributed.png)

Source: [quassel](http://bugs.quassel-irc.org/projects/quassel-irc/wiki)

## Usage

```
docker create --name=quassel-core -v /etc/localtime:/etc/localtime:ro -v <path to data>:/config -e PGID=<gid> -e PUID=<uid>  -p 4242:4242 linuxserver/quassel:latest
```

**Parameters**
* `-p` 4242 - the port quassel-core listens for connections on
* `-v` /etc/localhost for timesync - *optional*
* `-v` /config - database and quassel-core configuration storage
* `-e` PGID for for GroupID
* `-e` PUID for for UserID

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it quassel-core /bin/bash`.

## Updates

* Upgrade to the latest version simply `docker restart quassel-core`.
* To monitor the logs of the container in realtime `docker logs -f quassel-core`.


**Credits**
lonix <lonixx@gmail.com>
IronicBadger <ironicbadger@linuxserver.io>

**Versions**
* 2.1 LinuxServer.io related documentation updates
* 2.0 New gid\uid fix, and code cleanup.
* 1.0: Inital release