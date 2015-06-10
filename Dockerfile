FROM phusion/baseimage:0.9.16
MAINTAINER Stian Larsen <lonixx@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen

#Applying stuff
RUN add-apt-repository ppa:mamarley/quassel && \
apt-get update -qq && \
apt-get install quassel-core -yqq && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
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