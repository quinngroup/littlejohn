#!/bin/bash

# This script is run on what will eventually become the NameNode of the Hadoop
# cluster. Hadoop is all that is installed on metal.

# The SSH keys are generated, sent to the various slaves, and then Hadoop
# is downloaded and installed. Configuration of the cluster is up to the
# user.

# Needs admin privileges, though.
# if [ "$(whoami)" != "root" ]; then
#     echo "Must be run with sudo."
#     exit 1
# fi
if [$# != 2]; then
    echo "./0-namenode.sh <list of slaves> <slave username>"
    exit 1
fi

# Step 1: Generate SSH keys.
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""

# Step 2: Move the public key to each of the slaves.
while read p; do
    ssh-copy-id $2@$p
done <$1

# At this point, all the slaves should be accessible from the NameNode without
# needing a password anymore. In theory, that should make the rest of this
# setup script pretty easy, so let's hop to it.

# Step 3: Download and install the latest Hadoop version.
HADOOP_VERSION=2.7.1
HADOOP_PREFIX=/opt/hadoop

wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
tar zxvf hadoop-$HADOOP_VERSION.tar.gz
rm hadoop-$HADOOP_VERSION.tar.gz
mv hadoop-$HADOOP_VERSION $HADOOP_PREFIX
while read p; do
    scp -r $HADOOP_PREFIX $2@$p:$HADOOP_PREFIX

    # As long as we're at it...
    # Step 4: Perform apt updates and install Docker.
    ssh $2@$p sudo apt-get -y update && sudo apt-get -y install build-essential \
        wget openjdk-7-jdk python-dev python-boto libcurl4-nss-dev \
        libsasl2-dev maven libapr1-dev libsvn-dev openssh-server rsync &&
        wget -qO- https://get.docker.com/ | sh
done <$1
