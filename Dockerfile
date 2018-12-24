FROM lsiobase/alpine:3.8 as buildstage
############## build stage ##############

# package versions
ARG QUASSEL_VERSION="0.13.0"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	cmake \
	curl \
	dbus-dev \
	g++ \
	gcc \
	git \
	icu-dev \
	icu-libs \
	libressl \
	libressl-dev \
	make \
	paxmark \
	qt5-qtbase-dev \
	qt5-qtbase-postgresql \
	qt5-qtbase-sqlite \
	qt5-qtscript-dev \
	tar && \
 apk add --no-cache \
        --repository http://nl.alpinelinux.org/alpine/edge/community \
    qca 
 
RUN \
 echo "**** fetch source code  ****" && \
 mkdir -p \
	/tmp/quassel/build && \
 curl -o \
 /tmp/quassel-src.tar.gz -L \
	"https://github.com/quassel/quassel/archive/${QUASSEL_VERSION}.tar.gz" && \
 tar xf \
 /tmp/quassel-src.tar.gz -C \
	/tmp/quassel --strip-components=1

RUN \
 echo "**** compile quasselcore ****" && \
 cd /tmp/quassel && \
 cmake \
	-DCMAKE_INSTALL_PREFIX=/tmp/quassel/build/ \
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
 paxmark -m /tmp/quassel/build/bin/quasselcore

############## runtime stage ##############
FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	icu-libs \
	libressl \
	qt5-qtbase-postgresql \
	qt5-qtbase-sqlite \
	qt5-qtbase-x11 && \
 apk add --no-cache \
        --repository http://nl.alpinelinux.org/alpine/edge/community \
    qca 

# copy local files and buildstage artifacts
COPY root/ /
COPY --from=buildstage /tmp/quassel/build/bin/ usr/bin/
COPY --from=buildstage /tmp/quassel/build/share/ /usr/share/
