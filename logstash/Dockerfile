# DOCKER-VERSION 1.8.1
# VERSION v1

FROM zenoss/isvcs-base:latest
MAINTAINER Zenoss <dev@zenoss.com>

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN apt-get install -y openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*

# Install ElasticSearch
ENV ES_VERSION 1.3.1
ENV ES_PORT 9100
ENV ES_CLUSTERNAME elasticsearch_logstash
ADD es /tmp/es
RUN wget -qO- https://download.elasticsearch.org/elasticsearch/elasticsearch-$(ES_VERSION).tar.gz | tar -C /opt -xz; \
    /opt/elasticsearch-$(ES_VERSION)/bin/plugin -install mobz/elasticsearch-head; \
    sed -i -e 's/^.*http.port.*$$/http.port: $(ES_PORT)/' /opt/elasticsearch-$(ES_VERSION)/config/elasticsearch.yml; \
    sed -i -e 's/^.*cluster.name.*$$/cluster.name: $(ES_CLUSTERNAME)/' /opt/elasticsearch-$(ES_VERSION)/config/elasticsearch.yml; \
    cat /tmp/es/elasticsearch-addendum.yaml >> /opt/elasticsearch-$(ES_VERSION)/config/elasticsearch.yml; \
    /tmp/es/changeESLogProperties.sh /opt/elasticsearch-$(ES_VERSION)/config/logging.yml; \
    rm -rf /tmp/*

# Install logstash
ENV LOGSTASH_VERSION 1.4.2
RUN wget -qO- https://download.elasticsearch.org/logstash/logstash/logstash-$(LOGSTASH_VERSION).tar.gz | tar -C /opt -xz