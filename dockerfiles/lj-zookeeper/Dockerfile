# Base Zookeeper container. Based heavily on the version by sekka1/garland
# at https://github.com/sekka1/mesosphere-docker , which in turn was based on
# jplock's zookeeper image at https://github.com/jplock/docker-zookeeper .

FROM ubuntu:14.04.2
MAINTAINER Shannon Quinn <magsol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV ZOOKEEPER_VERSION 3.4.6

RUN apt-get update && apt-get install -y openjdk-7-jre-headless wget
RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ADD config/run.sh /opt/run.sh
RUN chmod 777 /opt/run.sh

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]
RUN /bin/bash /opt/run.sh
