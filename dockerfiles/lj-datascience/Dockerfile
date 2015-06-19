# Installs all the core data science tools, including Anaconda and OpenCV.

FROM magsol/lj-hadoop
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive

ENV ANACONDA_VERSION 2.2.0
ENV OPENCV_VERSION 3.0.0

# Install any apt prerequisites.
RUN apt-get -y update
RUN apt-get -y install cmake git libgtk2.0-dev pkg-config libavcodec-dev \
    libavformat-dev libswscale-dev libtbb2 libtbb-dev libtiff-dev \
    libjasper-dev libdc1394-22-dev unzip

# Install Anaconda first.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
RUN wget https://repo.continuum.io/archive/Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh
RUN /bin/bash /Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda-$ANACONDA_VERSION-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

RUN /opt/conda/bin/conda install --yes joblib shapely future seaborn

ADD requirements.txt /tmp/requirements.txt
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt && rm get-pip.py

# Now that Python is set up, install OpenCV.
RUN wget https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && rm $OPENCV_VERSION.zip
RUN mkdir opencv-$OPENCV_VERSION/build && cd opencv-$OPENCV_VERSION/build
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/opt/opencv ..
RUN make -j && make install
ENV PATH /opt/opencv:$PATH

CMD ["bin/bash"]