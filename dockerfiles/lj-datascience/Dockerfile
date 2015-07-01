# Installs all the core data science tools. These are as follows:
# - Anaconda (makes Python environments easy)
# - Additional Python modules (installed with pip)
# - OpenCV (and its dependencies, installed through apt-get)
# - Scala and sbt
# - Julia

FROM magsol/lj-base
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
RUN apt-get -y update
RUN apt-get -y install python-software-properties software-properties-common
RUN add-apt-repository -y ppa:staticfloat/juliareleases
ENV DEBIAN_FRONTEND noninteractive

ENV ANACONDA_VERSION 2.2.0
ENV OPENCV_VERSION 3.0.0
ENV SCALA_VERSION 2.10.5
ENV SBT_VERSION 0.13.8

# Go ahead and install Julia, along with updating package dependencies
# for Anaconda and OpenCV.
RUN apt-get -y update
RUN apt-get -y install cmake git libgtk2.0-dev pkg-config libavcodec-dev \
    libavformat-dev libswscale-dev libtbb2 libtbb-dev libtiff5-dev julia \
    libjasper-dev libdc1394-22-dev unzip libblas-dev liblapack-dev

# Install Anaconda.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > conda.sh && mv conda.sh /etc/profile.d/
RUN wget https://repo.continuum.io/archive/Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh
RUN /bin/bash /Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

# Install some extra Python libraries.
RUN /opt/conda/bin/conda install --yes joblib shapely future seaborn
ADD requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Now that Python is set up, install OpenCV.
RUN wget https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && rm $OPENCV_VERSION.zip
ADD build_opencv.sh /build_opencv.sh
RUN /bin/bash build_opencv.sh
RUN rm build_opencv.sh
ENV PATH /opt/opencv:$PATH

# Install SBT.
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
    tar zxvf sbt-$SBT_VERSION.tgz && rm sbt-$SBT_VERSION.tgz
RUN mv sbt /opt/sbt
ENV PATH /opt/sbt/bin:$PATH

# Finally, install Scala.
RUN wget http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
    tar zxvf scala-$SCALA_VERSION.tgz && rm scala-$SCALA_VERSION.tgz && \
    mv scala-$SCALA_VERSION /opt/scala
ENV PATH /opt/scala/bin:$PATH

ENTRYPOINT ["/bin/bash"]
