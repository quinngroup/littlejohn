# Sets up and configures a base Spark installation, used by master and client.

FROM magsol/anaconda
MAINTAINER Shannon Quinn "magsol@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Set some useful environment variables.
ENV SPARK_VERSION 1.4.1-bin-hadoop2.6
ENV SPARK_PREFIX /opt/spark
ENV PYSPARK_PYTHON python

# Download the Hadoop packages from distribution.
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION.tgz && \
    tar zxvf spark-$SPARK_VERSION.tgz && rm spark-$SPARK_VERSION.tgz
RUN mv spark-$SPARK_VERSION $SPARK_PREFIX
ENV PATH $PATH:$SPARK_PREFIX/bin
ENV PATH $PATH:$SPARK_PREFIX/sbin

# Move over the configuration files.
ADD spark/conf/* $SPARK_PREFIX/conf/
