# DOCKER-VERSION 1.8.1
# VERSION v1

FROM zenoss/isvcs-base:latest
MAINTAINER Zenoss <dev@zenoss.com>

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN apt-get install -y openjdk-7-jre-headless mvn && rm -rf /var/lib/apt/lists/*

# Install Zookeeper
ENV ZK_VERSION 3.4.5
ENV ZK_PORT 2181
RUN wget -qO- http://archive.apache.org/dist/zookeeper/zookeeper-$(ZK_VERSION)/zookeeper-$(ZK_VERSION).tar.gz | tar -C /opt -xz; \
    cp /opt/zookeeper-$(ZK_VERSION)/conf/zoo_sample.cfg /opt/zookeeper-$(ZK_VERSION)/conf/zoo.cfg; \
    echo clientPort=$(ZK_PORT) >> /opt/zookeeper-$(ZK_VERSION)/conf/zoo.cfg; \
    echo maxClientCnxns=0 >> /opt/zookeeper-$(ZK_VERSION)/conf/zoo.cfg; \
    echo autopurge.snapRetainCount=3 >> /opt/zookeeper-$(ZK_VERSION)/conf/zoo.cfg; \
    echo autopurge.purgeInterval=1 >> /opt/zookeeper-$(ZK_VERSION)/conf/zoo.cfg

# Install Exhibitor
ENV EXHIBITOR_VERSION v1.5.5
ENV EXHIBITOR_PORT 12181
RUN mkdir -p /opt/exhibitor; \
    wget -q -O /opt/exhibitor https://raw.githubusercontent.com/Netflix/exhibitor/$(EXHIBITOR_VERSION)/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml; \
    cd /opt/exhibitor && mvn assembly:single; \
    sed -i 's|start-foreground)|start-foreground)\n /usr/bin/java -jar /opt/exhibitor/target/exhibitor-*-jar-with-dependencies.jar -c file --port $(EXHIBITOR_PORT) \&|g' \
        /opt/zookeeper-$(ZK_VERSION)/ bin/zkServer.sh