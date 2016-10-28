FROM lsiobase/xenial
MAINTAINER sparklyballs

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"

ENV TEST=test
# add repositories
RUN \
 echo "deb http://ppa.launchpad.net/mamarley/quassel/ubuntu xenial main" >> /etc/apt/sources.list && \
 echo "deb-src http://ppa.launchpad.net/mamarley/quassel/ubuntu xenial main" >> /etc/apt/sources.list && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 26F4EF8440618B66 && \

# install packages
 apt-get update && \
 apt-get install -y \
	libqt5sql5-psql \
	libqt5sql5-sqlite \
	quassel-core \
	sqlite && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4242
VOLUME /config
