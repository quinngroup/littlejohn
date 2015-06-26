# Because evidently Docker can't handle commands like "cd".

mkdir opencv-$OPENCV_VERSION/build
cd opencv-$OPENCV_VERSION/build/
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/opt/opencv \
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
make -j && make install
cd /
rm -rf opencv-$OPENCV_VERSION