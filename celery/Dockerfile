# DOCKER-VERSION 1.8.1
# VERSION v1

FROM zenoss/isvcs-base:latest
MAINTAINER Zenoss <dev@zenoss.com>

RUN apt-get install -y redis-server; \
    wget -qO- https://bootstrap.pypa.io/get-pip.py | python

# TODO: Do not add celery into a virtual environment
ADD celery /tmp/celery
RUN cd /opt && virtualenv celery; \
    /opt/celery/bin/pip install -U celery[redis] pyes python-dateutil socketIO-client; \
    mkdir -p /opt/celery/var/log /opt/celery/var/redis /opt/celery/etc; \
    ln -s $RESOURCE_PATH/cpcelery.py /opt/celery/lib/python2.7/site-packages/cpcelery.py; \
    cp /tmp/celery/redis.conf /opt/celery/etc/redis.conf; \
    cp /tmp/celery-supervisor.conf /opt/celery/etc/supervisor.conf; \
    rm -rf /tmp/*