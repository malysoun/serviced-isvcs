FROM java:openjdk-7-jre
MAINTAINER Zenoss <dev@zenoss.com>

RUN mkdir /usr/local/serviced/resources -p # this is mounted in to every isvcs container
RUN apt-get update; \
    apt-get install -y -q supervisor redis-server liblzma-dev wget; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/*
RUN wget -qO- https://bootstrap.pypa.io/get-pip.py | python; \
    pip install --upgrade pip wheel;
ADD deps.tar.gz /
ADD supervisor.conf /opt/zenoss/etc/supervisor.conf
ADD registry.tar.gz /
ADD consumer.tar.gz /
ADD opentsdb.tar.gz /
ADD query.tar.gz /
ADD es_serviced.tar.gz /
ADD es_logstash.tar.gz /
ADD zk.tar.gz /
ADD logstash.tar.gz /
ADD celery.tar.gz /
RUN pip install --no-index --find-links=/deps/wheels -r /deps/requirements.txt
