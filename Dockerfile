FROM lsiobase/alpine:3.6
MAINTAINER sparklyballs

# package versions
ARG QUASSEL_VERSION="0.12.4"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install build packages
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

# install runtime packages
 apk add --no-cache \
	icu-libs \
	libressl \
	qt-postgresql \
	qt-sqlite && \

# compile quassel
 mkdir -p \
	/tmp/quassel/build && \
 curl -o \
 /tmp/quassel-src.tar.gz -L \
	"https://github.com/quassel/quassel/archive/${QUASSEL_VERSION}.tar.gz" && \
 tar xf \
 /tmp/quassel-src.tar.gz -C \
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

# determine build packages to keep
 COMMON_RUNTIME_PACKAGES="$( \
	scanelf --needed --nobanner /usr/bin/quassel \
	| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	| sort -u \
	| xargs -r apk info --installed \
	| sort -u \
	)" && \
 CORE_RUNTIME_PACKAGES="$( \
	scanelf --needed --nobanner /usr/bin/quasselcore \
	| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	| sort -u \
	| xargs -r apk info --installed \
	| sort -u \
	)" && \

# install packages dependant on searches above.
 apk add --no-cache \
	${COMMON_RUNTIME_PACKAGES} \
	${CORE_RUNTIME_PACKAGES} && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4242
VOLUME /config
