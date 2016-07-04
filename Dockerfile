FROM lsiobase/xenial
MAINTAINER sparklyballs

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN \
 echo "deb http://ppa.launchpad.net/mamarley/quassel/ubuntu xenial main" >> /etc/apt/sources.list && \
 echo "deb-src http://ppa.launchpad.net/mamarley/quassel/ubuntu xenial main" >> /etc/apt/sources.list && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 26F4EF8440618B66 && \
 apt-get update && \
 apt-get install -y \
	libqt4-sql-sqlite \
	quassel-core \
	sqlite && \

# cleanup
 apt-get clean && \
 rm -rfv \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 4242
