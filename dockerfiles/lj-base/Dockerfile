# Builds out the base install for the LittleJohn cluster nodes. Pretty much
# just installs Java on top of base Ubuntu.

FROM ubuntu:14.04.2
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive

# Install the basic packages.
RUN apt-get update
RUN apt-get install -y wget rsync build-essential openjdk-7-jdk vim emacs

# Set up SSH.
RUN apt-get -y update
RUN apt-get -y install openssh-server openssh-client runit && \
    mkdir -p /var/run/sshd && echo 'root:root' | chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /etc/ssh/sshd_config

ENV SSH_PORT 22
ENV SSH_OPTS -o StrictHostKeyChecking=no -p $SSH_PORT
ADD config/ssh /root/.ssh
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/config && \
    chmod 0400 /root/.ssh/id_rsa && \
    chown root:root -R /root/.ssh && \
    sed  -i "/^[^#]*UsePAM/ s/.*/#&/" /etc/ssh/sshd_config && \
    sed  -i "/^[^#]*Port/ s/.*/#&/" /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "Port $SSH_PORT" >> /etc/ssh/sshd_config

# Expose SSH port.
EXPOSE 22