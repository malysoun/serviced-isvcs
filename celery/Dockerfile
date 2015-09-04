# DOCKER-VERSION 1.8.1
# VERSION v1

FROM zenoss/isvcs-base:latest
MAINTAINER Zenoss <dev@zenoss.com>

RUN apt-get install -y redis-server supervisor; \
    wget -qO- https://bootstrap.pypa.io/get-pip.py | python 
# Install celery
# TODO: don't install celery in a virtualenv
RUN cd /opt && virtualenv celery; \
    /opt/celery/bin/pip install -U celery[redis] pyes python-dateutil socketIO-client; \
    mkdir -p /opt/celery/var/log /opt/celery/var/redis /opt/celery/etc; \
    ln -s $RESOURCE_PATH/cpcelery.py /opt/celery/lib/python2.7/site-packages/cpcelery.py
ADD redis.conf /opt/celery/etc/redis.conf
ADD celery-supervisor.conf /opt/celery/etc/supervisor.conf