# Base Marathon image. Based heavily on the version distributed by Mesosphere.

FROM ubuntu:14.04.2
MAINTAINER Shannon Quinn <magsol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV MARATHON_VERSION 0.8.2

# Install the custom apt-keys so we can have nice things / Mesos.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" | \
        tee /etc/apt/sources.list.d/mesosphere.list
RUN apt-get update
RUN apt-get -y install mesos python-software-properties wget curl openjdk-7-jre-headless

# Now download and install Marathon.
RUN wget http://downloads.mesosphere.com/marathon/v$MARATHON_VERSION/marathon-$MARATHON_VERSION.tgz && mv marathon-$MARATHON_VERSION.tgz /tmp/marathon.tgz
RUN mkdir -p /opt/marathon && tar xzf /tmp/marathon.tgz -C /opt/marathon --strip=1 && rm -f /tmp/marathon.tgz

EXPOSE 8080
WORKDIR /opt/marathon
CMD ["--help"]
ENTRYPOINT ["/opt/marathon/bin/start"]
