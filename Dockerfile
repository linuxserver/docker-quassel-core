FROM linuxserver/baseimage
MAINTAINER Stian Larsen <lonixx@gmail.com>
ENV APTLIST="quassel-core libqt4-sql-sqlite sqlite"


#Applying stuff
RUN add-apt-repository ppa:mamarley/quassel  && \
apt-get update -q && \
apt-get install \
-yqq $APTLIST && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh


# Volumes and Ports
VOLUME /config
EXPOSE 4242

