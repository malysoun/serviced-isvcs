# DOCKER-VERSION 1.8.1
# VERSION v1

FROM zenoss/isvcs-base:latest
MAINTAINER Zenoss <dev@zenoss.com>

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV COMPRESSION NONE
RUN apt-get install -y openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*; \
    mkdir -p /opt/zenoss/etc/supervisor
ADD supervisor.conf /opt/zenoss/etc/supervisor.conf


# Install HBase
ENV HBASE_VERSION 0.94.16
ENV HBASE_HOME /opt/hbase-$(HBASE_VERSION)
ENV HBASE_MANAGES_ZK true
ENV HBASE_PORT 9090
ADD hbase /tmp/hbase
RUN wget -qO- https://s3.amazonaws.com/pip.zenoss/binary_mirrors/hbase-$(HBASE_VERSION).tar.gz | tar -C /opt -xz; \
    cp /tmp/hbase/hbase_supervisor.conf /opt/zenoss/etc/supervisor/hbase_supervisor.conf; \
    cp /tmp/hbase/hbase-site.xml $(HBASE_HOME)/conf/hbase-site.xml; \
    cd $(HBASE_HOME) && patch -p0 < /tmp/hbase/hbase-daemon.sh.patch; \
    cd $(HBASE_HOME) && patch -p0 < /tmp/hbase/start-hbase.sh.patch; \
    /tmp/hbase/changeHbaseLogProperties.sh /opt/hbase-$(HBASE-VERSION)/conf/log4j.properties; \
    rm -rf /tmp/*

# Install OpenTSDB
ENV OPENTSDB_VERSION 2.1.0RC1
ENV OPENTSDB_PORT 4242
ADD opentsdb /tmp/opentsdb
RUN wget -q -O /tmp/opentsdb https://github.com/OpenTSDB/opentsdb/releases/download/v$(OPENTSDB_VERSION)/opentsdb-$(OPENTSDB_VERSION)_all.deb; \
    dpkg -i --instdir /opt/opentsdb /tmp/opentsdb/opentsdb-$(OPENTSDB_VERSION)_all.deb
    cp /tmp/opentsdb/start-opentsdb.sh /opt/opentsdb/build/start-opentsdb.sh; \
    cp /tmp/opentsdb/opentsdb_supervisor.conf /opt/zenoss/etc/supervisor/opentsdb_supervisor.conf; \
    rm -rf /tmp/*

# Install Metric Consumer
ENV CONSUMER_VERSION 0.1.1
ENV CONSUMER_PORT 8443
ENV CONSUMER_ADMIN_PORT 58443
ADD consumer /tmp/consumer
RUN wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/metric-consumer-app-$(CONSUMER_VERSION)-zapp.tar.gz | tar -C /opt/zenoss -xz; \
    chmod a+x /opt/zenoss/bin/metric-consumer-app.sh; \
    ln -s /opt/zenoss/etc/metric-consumer-app/metric-consumer-app_supervisor.conf /opt/zenoss/etc/supervisor; \
    /tmp/consumer/modifyConfigFile.sh /opt/zenoss/etc/metric-consumer-app/configuration.yaml; \
    rm -rf /tmp/*

# Install Query Service
ENV QUERY_VERSION 0.1.3
ENV QUERY_PORT 8888
ENV QUERY_ADMIN_PORT 58888
ADD query /tmp/query
RUN wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/central-query-$(QUERY_VERSION)-zapp-tar.gz | tar -C /opt/zenoss -xz; \
    chmod a+x /opt/zenoss/bin/central-query.sh; \
    ln -s /opt/zenoss/etc/central-query/central-query_supervisor.conf /opt/zenoss/etc/supervisor; \
    /tmp/query/modifyConfigFile.sh /opt/zenoss/etc/central-query/configuration.yaml; \
    rm -rf /tmp/*