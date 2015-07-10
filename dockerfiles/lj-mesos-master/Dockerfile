# Installs and configures the Mesos Master.

FROM magsol/lj-mesos-base
MAINTAINER Shannon Quinn <magsol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Some configuration options.
ENV MESOS_PORT 5050
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_REGISTRY in_memory
ENV MESOS_WORK_DIR /var/lib/mesos
ENV MESOS_QUORUM 1

ENTRYPOINT ["mesos-master"]
