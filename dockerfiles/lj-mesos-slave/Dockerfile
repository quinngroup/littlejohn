# Installs and configures the Mesos Slave.

FROM magsol/lj-mesos-base
MAINTAINER Shannon Quinn <magsol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# This cracks me up to no end.
RUN wget -qO- https://get.docker.com/ | sh

# Some configuration options.
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_LOGGING_LEVEL INFO
ENV MESOS_CONTAINERIZERS docker,mesos
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

ENTRYPOINT ["mesos-slave"]
