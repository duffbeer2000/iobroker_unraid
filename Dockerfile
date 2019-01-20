FROM debian:latest
#FROM debian:stable-slim

MAINTAINER Christian Schwarz

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    acl \
    apt-utils \
    arp-scan \
    build-essential \
    curl \
    ffmpeg \
    fping \
    git \
    gnupg2 \
    libavahi-compat-libdnssd-dev \
    libfontconfig \
    libpcap-dev \
    libpam0g-dev \
    libudev-dev \
    locales \
    nano \
    net-tools \
    procps \
    python \
    sudo \
    unzip \
    wget \
 && rm -rf /var/lib/apt/lists/*

#Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get update && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

## Sprache und Zeitzone
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \dpkg-reconfigure --frontend=noninteractive locales && \update-locale LANG=de_DE.UTF-8
ENV LANG de_DE.UTF-8 
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
ENV TZ Europe/Berlin

## Erstelle die benötigten Ordner
RUN sudo mkdir -p /opt/iobroker && chmod 777 /opt/iobroker/
RUN sudo mkdir -p /opt/scripts && chmod 777 /opt/scripts/

## Bereite die Installation vor
WORKDIR /opt/scripts/
ADD scripts/install.sh install.sh
RUN chmod +x install.sh

## Installieren von ioBroker
RUN /opt/scripts/install.sh

## Startscript installieren
WORKDIR /opt/iobroker/
ADD scripts/run.sh run.sh
RUN chmod +x run.sh
VOLUME /opt/iobroker/

RUN npm install node-gyp -g
RUN update-rc.d iobroker.sh remove

EXPOSE 8081 8082 8083 8084

ENV DEBIAN_FRONTEND teletype

CMD ["sh", "/opt/iobroker/run.sh"]

#ENTRYPOINT ["./run.sh"]
#CMD ["sh"]


#FROM mhart/alpine-node:8
#
## inspired by https://github.com/MehrCurry/docker-iobroker
#
#MAINTAINER André Wolski <andre@dena-design.de>
#
#RUN npm i -g npm
#RUN apk add --no-cache bash python build-base
#
#RUN mkdir -p /opt/iobroker/
#WORKDIR /opt/iobroker/
#RUN npm install iobroker --unsafe-perm && echo $(hostname) > .install_host
#RUN npm i --production --unsafe-perm
#ADD scripts/run.sh run.sh
#RUN chmod +x run.sh
#VOLUME /opt/iobroker/
#RUN npm audit fix
#RUN iobroker start
#
#
#EXPOSE 8081 8082 8083 8084 8089
#CMD /opt/iobroker/run.sh




#FROM mhart/alpine-node:8
#
#MAINTAINER Duffbeer2000
#
#RUN apk add --no-cache bash python build-base
#
#RUN mkdir -p /opt/iobroker/
#WORKDIR /opt/iobroker/
#RUN npm install iobroker --unsafe-perm
#RUN npm i --production --unsafe-perm
#ADD scripts/run.sh run.sh
#RUN chmod +x run.sh
#VOLUME /opt/iobroker/
#
#EXPOSE 8081 8082 8083 8084
#CMD /opt/iobroker/run.sh
