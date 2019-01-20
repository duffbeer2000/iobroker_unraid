FROM debian:latest
#FROM debian:stable-slim

MAINTAINER Christian Schwarz

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    libavahi-compat-libdnssd-dev \
    libudev-dev \
    libpam0g-dev \
    python \
    curl \
    unzip \
    sudo \
    wget \
    ffmpeg \
    fping \
    arp-scan \
    nano \
    locales \
    git \
    libpcap-dev \
    libfontconfig \
    gnupg2 \
    procps \
    acl

#Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs

## Sprache und Zeitzone
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \dpkg-reconfigure --frontend=noninteractive locales && \update-locale LANG=de_DE.UTF-8
ENV LANG de_DE.UTF-8 
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
ENV TZ Europe/Berlin

## Erstelle die benötigten Ordner
RUN sudo mkdir -p /opt/iobroker && chmod 777 /opt/iobroker/
RUN sudo mkdir -p /opt/scripts && chmod 777 /opt/scripts/

WORKDIR /opt/scripts/
ADD scripts/install.sh install.sh
RUN chmod +x install.sh

#RUN curl -sL /opt/scripts/install.sh | bash -
RUN /opt/scripts/install.sh

EXPOSE 8081 8082 8083 8084



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
