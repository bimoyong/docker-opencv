#!/bin/sh

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D CUDA_ARCH_BIN=5.3 \
    -D CUDA_FAST_MATH=1 \
    -D CUDNN_INCLUDE_DIR=/usr/local/cuda/include \
    -D CUDNN_LIBRARY=/usr/local/cuda/lib64/libcudnn.so \
    -D ENABLE_FAST_MATH=1 \
    -D HAVE_opencv_python3=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules \
    -D PYTHON_EXECUTABLE=$(which python3) \
    -D WITH_CUBLAS=1 \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D BUILD_EXAMPLES=ON ..
