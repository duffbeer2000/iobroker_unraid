FROM debian:latest

MAINTAINER Christian Schwarz

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y build-essential libavahi-compat-libdnssd-dev libudev-dev libpam0g-dev python apt-utils curl unzip sudo wget ffmpeg fping arp-scan nano
#   avahi-daemon git libpcap-dev  libfontconfig gnupg2 locales procps


## Sprache und Zeitzone
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \dpkg-reconfigure --frontend=noninteractive locales && \update-locale LANG=de_DE.UTF-8
ENV LANG de_DE.UTF-8 
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
ENV TZ Europe/Berlin


## Install node _6.x, _8.x, _9.x for V6/8/9
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs

## Install ioBroker
curl -sL https://raw.githubusercontent.com/ioBroker/ioBroker/stable-installer/installer.sh | bash -


EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084

#
#RUN sed -i '/^rlimit-nproc/s/^\(.*\)/#\1/g' /etc/avahi/avahi-daemon.conf
#
#RUN mkdir -p /opt/iobroker/ && chmod 777 /opt/iobroker/
#RUN mkdir -p /opt/scripts/ && chmod 777 /opt/scripts/
#
#WORKDIR /opt/scripts/
#
#ADD scripts/avahi_startup.sh avahi_startup.sh
#RUN chmod +x avahi_startup.sh
#RUN mkdir /var/run/dbus/
#
#ADD scripts/iobroker_startup.sh iobroker_startup.sh
#RUN chmod +x iobroker_startup.sh
#
#WORKDIR /opt/iobroker/
#
#RUN echo $(hostname) > .install_host && npm install iobroker --unsafe-perm && npm i --production --unsafe-perm
#RUN update-rc.d iobroker.sh remove
#RUN npm install node-gyp -g
#
#CMD ["sh", "/opt/scripts/iobroker_startup.sh"]
#
#ENV DEBIAN_FRONTEND teletype
