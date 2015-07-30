![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](http://linuxserver.io) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](http://forum.linuxserver.io) or for real-time support our [IRC](http://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/quassel-core

[Quassel IRC](http://quassel-irc.org/) is a modern, cross-platform, distributed IRC client, meaning that one (or multiple) client(s) can attach to and detach from a central core.

This container handles the IRC connection (quasselcore) and requires a desktop client (quasselclient) to be used and configured. It is designed to always on and will keep you present in IRC even when your clients cannot be online. 

![](http://bugs.quassel-irc.org/attachments/download/111/distributed.png)

Source: [quassel](http://bugs.quassel-irc.org/projects/quassel-irc/wiki)

## Usage

```
docker create \
	--name=quassel-core \
	-v /etc/localtime:/etc/localtime:ro \
	-v <path to data>:/config \
	-e PGID=<gid> -e PUID=<uid> \
	-p 4242:4242 \
	linuxserver/quassel:latest
```

**Parameters**

* `-p 4242` - the port quassel-core listens for connections on
* `-v /etc/localhost` for timesync - *optional*
* `-v /config` - database and quassel-core configuration storage
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation
* `-e WEBUI` for the optional WEbui set value to **1** to enable it.

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it quassel-core /bin/bash`.

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.  

## Setting up Quassel itself

A great place to host a quassel instance is a VPS, such as [DigitalOcean](https://www.digitalocean.com/?refcode=501c48b34b8c). For $5 a month you can have a 24/7 IRC connection and be up and running in under 55 seconds (or so they claim).

Once you have the container running, fire up a quassel desktop client and connect to your new core instance using your droplets public IP address and the port you specified in your `docker run` command *default: 4242*. Create an admin user, select SQLite as your storage backend (Quassel limitation). Setup your real name and nick, then press `Save & Connect`.

You're now connected to IRC. Let's add you to our [IRC](http://www.linuxserver.io/index.php/irc/) `#linuxserver.io` room on Freenode. Click 'File' > 'Networks' > 'Configure Networks' > 'Add' (under Networks section, not Servers) > 'Use preset' > Select 'Freenode' and then configure your identity using the tabs in the 'Network details' section. Once connected to Freenode, click `#join` and enter `#linuxserver.io`. That's it, you're done.

## Updates / Monitoring

* Upgrade to the latest version of Quassel simply `docker restart quassel-core`.
* Monitor the logs of the container in realtime `docker logs -f quassel-core`.


## Versions

* 30.07.15: Switched to internal baseimage, and fixed a bug with updateing the webinterface. 
* 06.07.15: Enabled BLOWFISH encryption and added a (optional) webinterface, for the times you dont have access to your client.
* 2.1 LinuxServer.io related documentation updates
* 2.0 New gid\uid fix, and code cleanup.
* 1.0: Inital release