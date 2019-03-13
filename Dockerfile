ARG BASE=alpine:latest
FROM $BASE AS builder

RUN apk add --no-cache \
  cmake \
  curl \
  dbus-dev \
  g++ \
  gcc \
  git \
  icu-dev \
  icu-libs \
  openssl \
  openssl-dev \
  openldap-dev \
  make \
  paxmark \
  qt5-qtbase-dev \
  qt5-qtscript-dev \
  qt5-qtbase-postgresql \
  qt5-qtbase-sqlite

RUN mkdir /quassel && \
    cd /quassel/ && \
    git clone -b 0.13 --single-branch https://github.com/quassel/quassel src && \
    cd /quassel/src/ && \
    git checkout 0.13.1
RUN mkdir /quassel/build && \
    cd /quassel/build && \
    CXXFLAGS="-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -fstack-protector-strong -fPIE -pie -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now" cmake \
      -DCMAKE_INSTALL_PREFIX=/quassel/install \
      -DCMAKE_BUILD_TYPE="Release" \
      -DUSE_QT5=ON \
      -DWITH_KDE=OFF \
      -DWANT_QTCLIENT=OFF \
      -DWANT_CORE=ON \
      -DWANT_MONO=OFF \
      /quassel/src
RUN cd /quassel/build && \
    make && \
    make install && \
    paxmark -m /quassel/install/bin/quasselcore

FROM $BASE

RUN apk add --no-cache \
  icu-libs \
  openssl \
  qt5-qtbase \
  qt5-qtscript \
  qt5-qtbase-postgresql \
  qt5-qtbase-sqlite

COPY --from=builder /quassel/install/bin /usr/bin/

RUN addgroup -g 1000 -S quassel && \
    adduser -S -G quassel -u 1000 -s /bin/bash -h /config quassel
USER quassel
VOLUME /config

EXPOSE 4242/tcp
EXPOSE 10113/tcp

ENV DB_BACKEND="SQLite"
ENV AUTH_AUTHENTICATOR="Database"
ENV DB_PGSQL_USERNAME="quassel"
ENV DB_PGSQL_PASSWORD=""
ENV DB_PGSQL_HOSTNAME="localhost"
ENV DB_PGSQL_PORT="5432"
ENV DB_PGSQL_DATABASE="quassel"
ENV AUTH_LDAP_HOSTNAME="ldap://localhost"
ENV AUTH_LDAP_PORT="389"
ENV AUTH_LDAP_BIND_DN=""
ENV AUTH_LDAP_BIND_PASSWORD=""
ENV AUTH_LDAP_BASE_DN=""
ENV AUTH_LDAP_FILTER=""
ENV AUTH_LDAP_UID_ATTRIBUTE="uid"

ENTRYPOINT ["quasselcore", "--configdir", "/config"]
