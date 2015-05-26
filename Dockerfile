FROM phusion/baseimage:0.9.15
MAINTAINER Stian Larsen <lonixx@gmail.com>
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen

Ye
#Applying stuff
RUN apt-get update -qq && \
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


# Volums and Ports
VOLUME /config
EXPOSE 4242