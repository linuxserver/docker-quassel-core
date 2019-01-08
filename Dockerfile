FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs & chbmb"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME /config

RUN \
 apt-get update && \
 apt-get install -y gnupg libqt5sql5-psql && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 26F4EF8440618B66 && \
 echo "**** add repository ****" && \
 echo "deb http://ppa.launchpad.net/mamarley/quassel/ubuntu bionic main" > \
        /etc/apt/sources.list.d/quassel.list && \
 echo "deb-src http://ppa.launchpad.net/mamarley/quassel/ubuntu bionic main" >> \
        /etc/apt/sources.list.d/quassel.list && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y quassel-core && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4242
VOLUME /config
