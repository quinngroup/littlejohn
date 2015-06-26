# Installs all the core data science tools. These are as follows:
# - Anaconda (makes Python environments easy)
# - Additional Python modules (installed with pip)
# - OpenCV (and its dependencies, installed through apt-get)
# - Scala and sbt
# - Julia

FROM magsol/lj-base
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive

ENV ANACONDA_VERSION 2.2.0
ENV OPENCV_VERSION 3.0.0
ENV SCALA_VERSION 2.10.5
ENV SBT_VERSION 0.13.8

# Go ahead and install Julia, along with updating package dependencies
# for Anaconda and OpenCV.
RUN add-apt-repository -y ppa:staticfloat/juliareleases && apt-get -y update
RUN apt-get -y install cmake git libgtk2.0-dev pkg-config libavcodec-dev \
    libavformat-dev libswscale-dev libtbb2 libtbb-dev libtiff5-dev julia \
    libjasper-dev libdc1394-22-dev unzip build-essential libblas-dev liblapack-dev

# Install Anaconda.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > conda.sh && mv conda.sh /etc/profile.d/
RUN wget https://repo.continuum.io/archive/Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh
RUN /bin/bash /Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

RUN /opt/conda/bin/conda install --yes joblib shapely future seaborn
ADD requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Now that Python is set up, install OpenCV.
RUN wget https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && rm $OPENCV_VERSION.zip
RUN mkdir opencv-$OPENCV_VERSION/build && cd opencv-$OPENCV_VERSION/build

RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/opt/opencv \
    -D PYTHON2_EXECUTABLE=/opt/conda/bin/python \
    -D PYTHON2_INCLUDE_DIR=/opt/conda/include/python2.7 \
    -D PYTHON2_INCLUDE_DIR2=/opt/conda/include/python2.7 \
    -D PYTHON2_LIBRARY=/opt/conda/lib/libpython2.7.so \
    -D PYTHON2_NUMPY_INCLUDE_DIRS=/opt/conda/lib/python2.7/site-packages/numpy/core/include \
    -D PYTHON2_PACKAGES_PATH=/opt/conda/lib/python2.7/site-packages \
    -D PYTHON_INCLUDE_DIR=/opt/conda/include/python2.7 \
    -D PYTHON_INCLUDE_DIR2=/opt/conda/include/python2.7 \
    -D PYTHON_LIBRARY=/opt/conda/lib/libpython2.7.so \
    ..
RUN make -j && make install
ENV PATH /opt/opencv:$PATH

# Install SBT.
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
    tar zxvf sbt-$SBT_VERSION.tgz && rm sbt-$SBT_VERSION.tgz
RUN mv sbt-$SBT_VERSION /opt/sbt
ENV PATH /opt/sbt/bin:$PATH

# Finally, install Scala.
RUN wget http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
    tar zxvf scala-$SCALA_VERSION.tgz && rm scala-$SCALA_VERSION.tgz && \
    mv scala-$SCALA_VERSION /opt/scala
ENV PATH /opt/scala/bin:$PATH

CMD ["bin/bash"]