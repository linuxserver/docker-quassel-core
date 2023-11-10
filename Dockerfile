# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.18 as build-stage

# build time arguements
ARG CXXFLAGS="\
	-D_FORTIFY_SOURCE=2 \
	-Wp,-D_GLIBCXX_ASSERTIONS \
	-fstack-protector-strong \
	-fPIE -pie -Wl,-z,noexecstack \
	-Wl,-z,relro -Wl,-z,now"
ARG QUASSEL_RELEASE
# install build packages
RUN \
  apk add --no-cache \
    boost-dev \
    build-base \
    cmake \
    dbus-dev \
    icu-dev \
    openssl-dev \
    openldap-dev \
    qt5-qtbase-dev \
    qt5-qtscript-dev \
    qt5-qtbase-postgresql \
    qt5-qtbase-sqlite \
    qca-dev \
    zlib-dev

# fetch source
RUN \
  mkdir -p \
    /tmp/quassel-src/build && \
  if [ -z ${QUASSEL_RELEASE+x} ]; then \
    QUASSEL_RELEASE=$(curl -sX GET "https://api.github.com/repos/quassel/quassel/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  curl -o \
  /tmp/quassel.tar.gz -L \
    "https://github.com/quassel/quassel/archive/${QUASSEL_RELEASE}.tar.gz" && \
  tar xf \
  /tmp/quassel.tar.gz -C \
    /tmp/quassel-src --strip-components=1

# build package
RUN \
  cd /tmp/quassel-src/build && \
  cmake \
    -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DWANT_CORE=ON \
    -DWANT_MONO=OFF \
    -DWANT_QTCLIENT=OFF \
    -DWITH_KDE=OFF \
    /tmp/quassel-src && \
  make -j2 && \
  make DESTDIR=/build/quassel install

FROM ghcr.io/linuxserver/baseimage-alpine:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG QUASSEL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

# set environment variables
ENV HOME /config

# install runtime packages
RUN \
  apk add --no-cache \
    icu-libs \
    openssl \
    qt5-qtbase \
    qt5-qtbase-postgresql \
    qt5-qtbase-sqlite \
    qt5-qtscript \
    libqca \
    openldap

# copy artifacts build stage
COPY --from=build-stage /build/quassel/usr/ /usr/

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 4242 10113
