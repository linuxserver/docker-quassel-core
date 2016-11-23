FROM lsiobase/alpine:edge
MAINTAINER sparklyballs

# build variables
ARG QUASSEL_VERSION="0.12.4"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	cmake \
	curl \
	dbus-dev \
	g++ \
	gcc \
	git \
	icu-dev \
	libressl-dev \
	make \
	paxmark \
	qca-dev \
	qt-dev \
	tar && \

# compile quassel
 mkdir -p \
	/tmp/quassel/build && \
 curl -o \
 /tmp/quassel-src.tar.bz2 -L \
	"http://www.quassel-irc.org/pub/quassel-${QUASSEL_VERSION}.tar.bz2" && \
 tar xf \
 /tmp/quassel-src.tar.bz2 -C \
	/tmp/quassel --strip-components=1 && \
 cd /tmp/quassel && \
 cmake \
	-DCMAKE_INSTALL_PREFIX=/usr/ \
	-DWITH_KDE=0 \
	-DCMAKE_BUILD_TYPE="Release" \
	-DWITH_OPENSSL=ON \
	-DWANT_CORE=ON \
	-DWANT_MONO=ON \
	-DWANT_QTCLIENT=OFF \
	-DWITH_DBUS=OFF \
	-DWITH_OXYGEN=OFF \
	-DWITH_PHONON=OFF \
	-DWITH_WEBKIT=OFF \
	../quassel && \
 make && \
 make install install/fast && \
 paxmark -m /usr/bin/quasselcore && \

# determine build packages to keep
 RUNTIME_PACKAGES="$( \
	scanelf --needed --nobanner /usr/bin/quasselcore \
	| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	| sort -u \
	| xargs -r apk info --installed \
	| sort -u \
	)" && \

# install runtime packages
 apk add --no-cache \
	${RUNTIME_PACKAGES} \
	icu-libs \
	qt-postgresql \
	qt-sqlite && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4242
VOLUME /config
