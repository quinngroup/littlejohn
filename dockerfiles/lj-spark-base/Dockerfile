# Installs Miniconda and uses the conda installer to add a bunch of additional
# packages. Uses pip to install whatever remains.

FROM centos
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
#ENV DEBIAN_FRONTEND noninteractive

# Install the basic packages.
RUN yum install -y wget rsync kernel-devel java-1.7.0-* vim emacs

# Set up SSH.
RUN yum -y update
RUN yum -y install openssh-server openssh-client runit && \
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

# A few prerequisites.
RUN yum install -y make gcc g++ build-essential cmake gcc-c++
RUN yum -y update && yum -y install blas-devel lapack-devel bzip2

# Install Anaconda.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > conda.sh && mv conda.sh /etc/profile.d/
RUN wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN chmod +x Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda-latest-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH
RUN conda update -y --all

# Install some extra Python libraries.
RUN /opt/conda/bin/conda install --yes astropy beautiful-soup blaze-core \
    bokeh bottleneck cython dask decorator freetype future gensim h5py hdf5 \
    ipython joblib libpng libsodium libtiff libxml2 llvmlite matplotlib nltk \
    numba numpy opencv pandas pep8 pillow pip protobuf pyamg scikit-image \
    scikit-learn scipy seaborn shapely sqlalchemy sqlite starcluster toolz \
    tornado twisted xray
ADD requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt



# install spark

# Set some useful environment variables.
ENV SPARK_VERSION 1.5.2-bin-hadoop2.6
ENV SPARK_PREFIX /opt/spark
ENV PYSPARK_PYTHON python
ENV SPARK_SSH_PORT 22
ENV SPARK_SSH_OPTS -o StrictHostKeyChecking=no -p $SPARK_SSH_PORT
ENV JAVA_HOME /usr/lib/jvm/jre-1.7.0-openjdk/

# Download the Hadoop packages from distribution.
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION.tgz && \
    tar zxvf spark-$SPARK_VERSION.tgz && rm spark-$SPARK_VERSION.tgz
RUN mv spark-$SPARK_VERSION $SPARK_PREFIX
ENV PATH $PATH:$SPARK_PREFIX/bin
ENV PATH $PATH:$SPARK_PREFIX/sbin