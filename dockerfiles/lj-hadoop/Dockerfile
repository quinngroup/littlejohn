# Downloads the base Hadoop packages. We don't need no stinkin' YARN.

FROM magsol/lj-base
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive

# Set some useful environment variables.
ENV HADOOP_VERSION 2.7.0
ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/conf
ENV HADOOP_COMMON_HOME $HADOOP_PREFIX
ENV HADOOP_HDFS_HOME $HADOOP_PREFIX
ENV HADOOP_MAPRED_HOME $HADOOP_PREFIX

# Yes.
ENV PATH $PATH:$HADOOP_PREFIX/bin
ENV PATH $PATH:$HADOOP_PREFIX/sbin

# Download the Hadoop packages from distribution.
RUN wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN tar zxvf hadoop-$HADOOP_VERSION.tar.gz
RUN rm hadoop-$HADOOP_VERSION.tar.gz
RUN mv hadoop-$HADOOP_VERSION $HADOOP_PREFIX

# Configure Hadoop.
ADD etc/hadoop/* $HADOOP_PREFIX/etc/hadoop/

# Set up SSH.
ENV SSH_PORT 2112
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

# Expose the requisite ports.
# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090
# Mapred ports
EXPOSE 19888
