FROM phusion/baseimage:0.9.16
MAINTAINER Stian Larsen <lonixx@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen

#Applying stuff
RUN add-apt-repository ppa:mamarley/quassel  && \
curl -sL https://deb.nodesource.com/setup | bash -  && \
apt-get dist-upgrade -yqq && \
apt-get install nodejs quassel-core libqca2-plugin-ossl libqt4-sql-sqlite git build-essential sqlite -yqq && \
npm -g install n && n latest  && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
ADD settings-user.js /default/settings-user.js
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh


#Adduser
RUN useradd -u 911 -U -s /bin/false abc
RUN usermod -G users abc


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]


# Volumes and Ports
VOLUME /config
EXPOSE 4242
EXPOSE 64443
