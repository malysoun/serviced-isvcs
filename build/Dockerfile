FROM ubuntu:trusty
MAINTAINER Zenoss <dev@zenoss.com>

RUN mkdir /usr/local/serviced/resources -p # this is mounted in to every isvcs container
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list; \
    echo "deb http://security.ubuntu.com/ubuntu trusty-security main universe" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y wget; \
    wget -qO- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | apt-key add -; \
    echo deb http://ceph.com/debian-giant/ trusty main | tee /etc/apt/sources.list.d/ceph-giant.list; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y -q --force-yes libc6=2.19-0ubuntu6.4 libc6-dev openjdk-7-jre-headless gnuplot-nox supervisor make ceph \
    redis-server git-core \
    libevent1-dev liblzma-dev; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*_* /tmp/*
RUN apt-get update; \
    apt-get install -y build-essential python-dev python-openssl liblzma-dev git; \
    cd /tmp; \
    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py; \
    python get-pip.py; \
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py; \
    python ez_setup.py
RUN pip install backports.lzma==0.0.2
RUN git clone --branch 0.7.3 --depth 1 https://github.com/dotcloud/docker-registry.git && \
    cd docker-registry && \
    echo "serviced:"                                                               >> config/config_sample.yml && \
    echo "  <<: *local"                                                            >> config/config_sample.yml && \
    echo "  sqlalchemy_index_database: _env:SQLALCHEMY_INDEX_DATABASE:sqlite:////tmp/registry/docker-registry.db" >> config/config_sample.yml && \
    echo "  loglevel: debug"                                                       >> config/config_sample.yml && \
    pip install /docker-registry/
RUN pip install elasticsearch-curator
ADD supervisor.conf /opt/zenoss/etc/supervisor.conf
ADD consumer.tar.gz /
ADD opentsdb.tar.gz /
ADD query.tar.gz /
ADD es_serviced.tar.gz /
ADD es_logstash.tar.gz /
ADD zk.tar.gz /
ADD logstash.tar.gz /
ADD celery.tar.gz /
ADD ceph.tar.gz /
