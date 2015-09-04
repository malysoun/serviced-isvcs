# DOCKER-VERSION 1.8.1
# VERSION v1

FROM zenoss/isvcs-base:latest
MAINTAINER Zenoss <dev@zenoss.com>

ENV CONSUMER_VERSION 0.1.1

RUN apt-get install -y openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/zenoss/log /opt/zenoss/etc/supervisor /opt/zenoss/var; \
    wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/metric-consumer-app-$(CONSUMER_VERSION)-zapp.tar.gz | tar -C /opt/zenoss -xz; \
    chmod a+x /opt/zenoss/bin/metric-consumer-app.sh; \
    ln -s /opt/zenoss/etc/metric-consumer-app/metric-consumer-app_supervisor.conf /opt/zenoss/etc/supervisor; \
    


ADD modifyConfigFile.sh

wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/metric-consumer-app-$(CONSUMER_VERSION)-zapp.tar.gz | tar -C /opt/zenoss -xz; \
    chmod a+x /opt/zenoss/bin/metric-consumer-app.sh; \
    ln -s /opt/zenoss/etc/metric-consumer-app/metric-consumer-app_supervisor.conf /opt/zenoss/etc/supervisor; \
    ./modifyConfigFile.sh /opt/zenoss/etc/metric-consumer-app/configuration.yaml; \
    rm modifyConfigFile.sh