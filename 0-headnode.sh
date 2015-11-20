# This script is a generic attempt to initialize a newly-created head node
# as part of a Mesos-powered Hadoop-driven Dockerized cluster.
#
# This script should be run as ROOT.
# 
# The stack is as follows:
# - Basic RHEL-related dependencies
# - Mesos on metal
# - Hadoop (for HDFS) on metal

# STEP 0: Define some variables so that the version of this software we use
# is easy to update.
HADOOP_VERSION=2.7.1
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

# STEP 1: Install some basic RHEL dependencies.
# This will make installing everything either much easier or outright possible.
yum install -y java-1.7.0-*
yum install -y lapack* blas*
yum install -y git vim
yum install -y make gcc gcc-c++ kernel-devel cmake

# STEP 2: Install Hadoop.
wget http://www.gtlib.gatech.edu/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
tar zxvf hadoop-${HADOOP_VERSION}.tar.gz && rm hadoop-{$HADOOP_VERSION}.tar.gz
mkdir /opt/hadoop && mv hadoop-${HADOOP_VERSION} /opt/hadoop/
mkdir /opt/hdfs
export PATH=$PATH:/opt/hadoop/hadoop-${HADOOP_VERSION}/bin

# Move over some configuration files.
cp templates/hadoop/* /opt/hadoop/hadoop-${HADOOP_VERSION}/etc/hadoop/

# STEP 3: Install Mesos.
# Add the Mesosphere repository.
rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum -y install mesos

# STEP 4: Install Docker.
wget -qO- https://get.docker.com/ | sh
