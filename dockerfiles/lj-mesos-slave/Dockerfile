# Installs and configures the Mesos Slave.

FROM magsol/lj-mesos-base
MAINTAINER Shannon Quinn <magsol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# This cracks me up to no end.
RUN wget -qO- https://get.docker.com/ | sh

# Would be nice to run Docker images out of Mesos.
RUN mkdir -p /etc/mesos-slave
RUN echo "docker,mesos" > /etc/mesos-slave/containerizers
RUN echo "5mins" > /etc/mesos-slave/executor_registration_timeout

# Some configuration options.
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_LOGGING_LEVEL INFO

ENTRYPOINT ["mesos-slave"]
