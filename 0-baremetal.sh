#!/bin/bash
# This script is run on the bare metal.

# Step 0: Let's define some variables.
HADOOP_VERSION=2.7.0
HADOOP_PREFIX=/opt/hadoop

MESOS_VERSION=0.22.1
MESOS_PREFIX=/opt/mesos

# Step 1: Perform the apt updates and install Docker.
apt-get -y update
apt-get -y install build-essential wget openjdk-7-jdk python-dev python-boto \
    libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev
wget -qO- https://get.docker.com/ | sh

# Step 2: Install Docker Compose (or decking).
# wget https://bootstrap.pypa.io/get-pip.py
# python get-pip.py
# pip install -U docker-compose

# Step 2: Install Hadoop. We're not strictly using Hadoop MapReduce so much
# as HDFS; this is where we store the data long-term. Containers are just
# for ephemeral analysis. Which means we also need to configure Hadoop.
wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
tar zxvf hadoop-$HADOOP_VERSION.tar.gz
rm hadoop-$HADOOP_VERSION.tar.gz
mv hadoop-$HADOOP_VERSION $HADOOP_PREFIX

## TODO: Make a .bashrc supplement with the needed Hadoop environment vars.

# Step 3: Install Mesos.
wget http://www.apache.org/dist/mesos/$MESOS_VERSION/mesos-$MESOS_VERSION.tar.gz
tar zxvf mesos-$MESOS_VERSION.tar.gz
rm mesos-$MESOS_VERSION.tar.gz
mkdir mesos-$MESOS_VERSION/build
cd mesos-$MESOS_VERSION/build
../configure --prefix=$MESOS_PREFIX
# make -j 8 && make check && make install
# chmod +x /usr/local/etc/mesos/*.template
# mv /usr/local/etc/mesos/mesos-deploy-env.sh.template /usr/local/etc/mesos/mesos-deploy-env.sh
# mv /usr/local/etc/mesos/mesos-master-env.sh.template /usr/local/etc/mesos/mesos-master-env.sh
# mv /usr/local/etc/mesos/mesos-slave-env.sh.template /usr/local/etc/mesos/mesos-slave-env.sh


# Step 3: Pull down the Docker image and get to work.
