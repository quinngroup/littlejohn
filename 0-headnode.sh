# This script is a generic attempt to initialize a newly-created head node
# as part of a Mesos-powered Hadoop-driven Dockerized cluster.
#
# This script should be run as ROOT.
# 
# The stack is as follows:
# - Basic RHEL-related dependencies
# - Mesos on metal
# - Hadoop (for HDFS) on metal
# - Docker on metal
# - Lots of docker containers

# STEP 0: Define some variables so that the version of this software we use
# is easy to update.
HADOOP_VERSION=2.7.1
SPARK_VERSION=1.5.2
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

# STEP 1: Install some basic RHEL dependencies.
# This will make installing everything either much easier or outright possible.
yum install -y java-1.7.0-*
yum install -y lapack* blas*
yum install -y git vim
yum install -y make gcc gcc-c++ kernel-devel cmake

# These packages allow installing "non-sanctioned" RH packages.
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum -y update
rm epel-release-latest-7.noarch.rpm

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


mkdir /opt/spark
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop1.tgz && \
	tar zxvf spark-1.5.0-bin-hadoop1.tgz && rm spark-1.5.0-bin-hadoop1.tgz
mv spark-1.5.0-bin-hadoop1 /opt/spark/
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop2.6.tgz && \
	tar zxvf spark-1.5.0-bin-hadoop2.6.tgz && rm spark-1.5.0-bin-hadoop2.6.tgz
mv spark-1.5.0-bin-hadoop2.6 /opt/spark/

wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
chmod +x Miniconda-latest-Linux-x86_64.sh && ./Miniconda-latest-Linux-x86_64.sh -b -p /opt/conda
rm Miniconda-latest-Linux-x86_64.sh
export PATH=/opt/conda/bin:$PATH
conda update -y --all
conda install -y astropy beautiful-soup blaze-core bokeh bottleneck cython dask decorator \
	freetype future gensim h5py hdf5 ipython joblib libpng libsodium libtiff libxml2 llvmlite \
	matplotlib nltk numba numpy opencv pandas pep8 pillow pip protobuf pyamg \
	scikit-image scikit-learn scipy seaborn shapely sqlalchemy sqlite starcluster toolz \
	tornado twisted xray
pip install thunder-python
pip install bolt-python
pip install picos
pip install sima
pip install click
pip install plotly
pip install toyplot
pip install mechanize
pip install tweepy
pip install pycallgraph
pip install awscli
pip install DAWG
pip install chainer
pip install optunity
pip install mahotas
