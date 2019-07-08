[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!

# [linuxserver/quassel-core](https://github.com/linuxserver/docker-quassel-core)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/quassel-core.svg)](https://microbadger.com/images/linuxserver/quassel-core "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/quassel-core.svg)](https://microbadger.com/images/linuxserver/quassel-core "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/quassel-core.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/quassel-core.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-quassel-core/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-quassel-core/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/quassel-core/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/quassel-core/latest/index.html)

[Quassel-core](http://quassel-irc.org/) is a modern, cross-platform, distributed IRC client, meaning that one (or multiple) client(s) can attach to and detach from a central core.

This container handles the IRC connection (quasselcore) and requires a desktop client (quasselclient) to be used and configured. It is designed to be always on and will keep your identity present in IRC even when your clients cannot be online. Backlog (history) is downloaded by your client upon reconnection allowing infinite scrollback through time.


[![quassel-core](http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/256/Apps-quassel-icon.png)](http://quassel-irc.org/)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/). 

Simply pulling `linuxserver/quassel-core` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=quassel-core \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e RUN_OPTS=--config-from-environment `#optional` \
  -p 4242:4242 \
  -p 113:10113 `#optional` \
  -v <path to data>:/config \
  --restart unless-stopped \
  linuxserver/quassel-core
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  quassel-core:
    image: linuxserver/quassel-core
    container_name: quassel-core
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - RUN_OPTS=--config-from-environment #optional
    volumes:
      - <path to data>:/config
    ports:
      - 4242:4242
      - 113:10113 #optional
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 4242` | The port quassel-core listens for connections on. |
| `-p 10113` | Optional Ident Port |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e RUN_OPTS=--config-from-environment` | Custom CLI options for Quassel |
| `-v /config` | Database and quassel-core configuration storage. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Application Setup

Quassel wiki: [quassel](http://bugs.quassel-irc.org/projects/quassel-irc/wiki)

A great place to host a quassel instance is a VPS, such as [DigitalOcean](https://www.digitalocean.com/?refcode=501c48b34b8c). For $5 a month you can have a 24/7 IRC connection and be up and running in under 55 seconds (or so they claim).

Once you have the container running, fire up a quassel desktop client and connect to your new core instance using your droplets public IP address and the port you specified in your `docker run` command *default: 4242*. Create an admin user, select SQLite as your storage backend (Quassel limitation). Setup your real name and nick, then press `Save & Connect`.

You're now connected to IRC. Let's add you to our [IRC](http://www.linuxserver.io/index.php/irc/) `#linuxserver.io` room on Freenode. Click 'File' > 'Networks' > 'Configure Networks' > 'Add' (under Networks section, not Servers) > 'Use preset' > Select 'Freenode' and then configure your identity using the tabs in the 'Network details' section. Once connected to Freenode, click `#join` and enter `#linuxserver.io`. That's it, you're done.

## Stateless usage

To use Quassel in stateless mode, where it needs to be configured through
environment arguments, run it with the `--config-from-environment` RUN_OPTS environment setting.

| Env | Usage |
| :----: | --- |
| DB_BACKEND | `SQLite` or `PostgreSQL` |
| DB_PGSQL_USERNAME | PostgreSQL User |
| DB_PGSQL_PASSWORD | PostgreSQL Password |
| DB_PGSQL_HOSTNAME | PostgreSQL Host |
| DB_PGSQL_PORT | PostgreSQL Port |
| AUTH_AUTHENTICATOR | `Database` or `LDAP` |
| AUTH_LDAP_HOSTNAME | LDAP Host |
| AUTH_LDAP_PORT | LDAP Port |
| AUTH_LDAP_BIND_DN | LDAP Bind Domain |
| AUTH_LDAP_BIND_PASSWORD | LDAP Password |
| AUTH_LDAP_FILTER | LDAP Authentication Filters |
| AUTH_LDAP_UID_ATTRIBUTE | LDAP UID |

Additionally you have RUN_OPTS that can be used to customize pathing and behvior.

| Option | Example |
| :----: | --- |
| --strict-ident | strictly bool `--strict-ident` |
| --ident-daemon | strictly bool `--ident-daemon` |
| --ident-port | `--ident-port "10113"` |
| --ident-listen | `--ident-listen "::,0.0.0.0"` |
| --ssl-cert | `--ssl-cert /config/keys/cert.crt` |
| --ssl-key | `--ssl-key /config/keys/cert.key` |
| --require-ssl | strictly bool `--require-ssl` |

Minimal example with SQLite:

```
docker create \
  --name=quassel-core \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e RUN_OPTS='--config-from-environment' \
  -e DB_BACKEND=SQLite \
  -e AUTH_AUTHENTICATOR=Database \
  -p 4242:4242 \
  -v <path to data>:/config \
  --restart unless-stopped \
  linuxserver/quassel-core
```



## Support Info

* Shell access whilst the container is running: `docker exec -it quassel-core /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f quassel-core`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' quassel-core`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/quassel-core`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/quassel-core`
* Stop the running container: `docker stop quassel-core`
* Delete the container: `docker rm quassel-core`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start quassel-core`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull quassel-core`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d quassel-core`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once quassel-core
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic: 
```
git clone https://github.com/linuxserver/docker-quassel-core.git
cd docker-quassel-core
docker build \
  --no-cache \
  --pull \
  -t linuxserver/quassel-core:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **28.06.19:** - Rebasing to alpine 3.10.
* **23.03.19:** - Switching to new Base images, shift to arm32v7 tag.
* **20.03.19:** - Make stateless operation an option, with input from one of the quassel team.
* **26.01.19:** - Add pipeline logic and multi arch.
* **08.01.19:** - Rebase to Ubuntu Bionic and upgrade to Quassel`0.13.0` See [here.](https://quassel-irc.org/node/134).
* **30.07.18:** - Rebase to alpine:3.8 and use buildstage.
* **03.01.18:** - Deprecate cpu_core routine lack of scaling.
* **09.12.17:** - Rebase to alpine:3.7.
* **26.11.17:** - Use cpu core counting routine to speed up build time.
* **12.07.17:** - Add inspect commands to README, move to jenkins build and push.
* **27.05.17:** - Rebase to alpine:3.6.
* **13.05.17:** - Switch to git source.
* **28.12.16:** - Rebase to alpine:3.5.
* **23.11.16:** - Rebase to alpine:edge.
* **23.09.16:** - Use QT5 dependencies (thanks bauerj).
* **10.09.16:** - Add layer badges to README.
* **28.08.16:** - Add badges to README.
* **10.08.16:** - Rebase to xenial.
* **14.10.15:** - Removed the webui, turned out to be to unstable for most usecases.
* **01.09.15:** - Fixed mistake in README.
* **30.07.15:** - Switched to internal baseimage, and fixed a bug with updating the webinterface.
* **06.07.15:** - Enabled BLOWFISH encryption and added a (optional) webinterface, for the times you dont have access to your client.
