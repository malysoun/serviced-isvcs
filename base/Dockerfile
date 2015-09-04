# DOCKER-VERSION 1.8.1
# VERSION v1

FROM ubuntu:trusty
MAINTAINER Zenoss <dev@zenoss.com>

ENV TERM xterm
ENV RESOURCE_PATH /usr/local/serviced/resources
RUN apt-get update && \
    apt-get install -y wget unzip vim supervisor && \
    apt-get clean; \
    mkdir -p $RESOURCE_PATH 