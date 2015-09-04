FROM ubuntu:trusty
MAINTAINER Zenoss <dev@zenoss.com>

ENV COMPRESSION=NONE HBASE_HOME=/opt/hbase-0.94.16 JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 
RUN apt-get update && \
    apt-get install -y build-essential openjdk-7-jdk git build-essential libtool wget supervisor python-pip python-dev maven librados-dev ruby-dev rpm liblzma-dev autoconf; \
    pip install --upgrade pip wheel virtualenv; \
    gem install fpm; \
    cd /root; \
    wget --quiet https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz; \
    tar -xf go1.4.2.linux-amd64.tar.gz; \
    rm go1.4.2.linux-amd64.tar.gz; \
    mv go /usr/local/go;
ENV GOROOT=/usr/local/go GOPATH=/root/go PATH=/usr/local/go/bin:/root/go/bin:$PATH
