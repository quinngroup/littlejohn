# Installs Mesos. Defaults to master, but this can be overridden using entrypoint.
# Based heavily on sekka1/garland's mesosphere-docker-base-image and
# mesosphere-docker-mesos-master.

FROM ubuntu:14.04.2
MAINTAINER Shannon Quinn <magsol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install the custom apt-keys so we can have nice things / Mesos.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF &&
    echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" | \
        tee /etc/apt/sources.list.d/mesosphere.list
RUN apt-get -y update && apt-get -y install curl \
    python-setuptools python-pip python-dev python-protobuf wget

# Install Zookeeper (apparently we need it?) and Mesos.
# Not going to start it on runtime though.
RUN apt-get -y install zookeeperd
RUN echo 1 | dd of=/var/lib/zookeeper/myid

# Install mesos.
RUN apt-get -y install mesos
RUN mkdir -p /etc/mesos-master
RUN echo "in_memory" > /etc/mesos-master/registry
RUN echo "docker,mesos" > /etc/mesos-slave/containerizers
RUN echo "5mins" > /etc/mesos-slave/executor_registration_timeout

# Some configuration options.
EXPOSE 5050
ENV MESOS_PORT 5050
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_REGISTRY in_memory
ENV MESOS_WORK_DIR /var/lib/mesos
ENV MESOS_LOGGING_LEVEL INFO

ENTRYPOINT ["mesos-master"]
