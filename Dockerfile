FROM phusion/baseimage:0.9.16
MAINTAINER Stian Larsen <lonixx@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen

#Applying stuff
#RUN add-apt-repository ppa:mamarley/quassel 
RUN curl -sL https://deb.nodesource.com/setup | bash - 
RUN apt-get dist-upgrade -yqq
RUN apt-get install nodejs quassel-core libqt4-sql-sqlite git build-essential sqlite -yqq
RUN npm -g install n && n latest 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


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

#Lonix's private testing command dont remove before production.
# docker run -p 4242 -p 64443 -e PUID=500 -e PGID=500 -e WEBUI=1 -v /tmp/config:/config web