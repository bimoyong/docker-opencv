ARG OWNER
ARG CUDA_VER
ARG PYTHON_VER
ARG OS
FROM --platform=$TARGETPLATFORM $OWNER/cuda:$CUDA_VER-devel-$OS

ARG CUDA_VER
ARG PYTHON_VER
ARG OPENCV_VER
ARG TARGETARCH
ARG DEBIAN_FRONTEND=noninteractive

COPY script /tmp/script

RUN \
    # Make sure that our Ubuntu system is perfectly updated
    apt update -y && apt upgrade -y && \
    apt install -y --no-install-recommends \
    # There are a series of I / O libraries necessary for OpenCV 4 to manage the image and video formats.
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libxvidcore-dev libx264-dev \
    # Now another important library necessary for a correct compilation of the OpenCV 4 source code is the GTK library, useful for managing the GUI (graphical user interfaces).
    libgtk-3-dev \
    # Install these very important development tools that we will need for compiling the OpenCV 4 source code
    build-essential cmake wget \
    # Then we add two more libraries needed for OpenCV mathematical optimization: Fortran and Atlas.
    libatlas-base-dev gfortran \
    # And finally, as mentioned above, we will rely on the version of Python 3.x. So if it is not yet installed on your system, the time has come to do it.
    python$PYTHON_VER-dev python3-pip && \
    echo 'alias python=python3' >> ~/.bash_aliases && \
    echo 'alias pip=pip3' >> ~/.bash_aliases && \
    pip install -v --no-cache-dir --upgrade pip && \
    pip install -v --no-cache-dir numpy && \
    # Install cuDNN
    cd /tmp && \
    wget -c http://developer.download.nvidia.com/compute/redist/cudnn/v8.0.3/cudnn-$CUDA_VER-linux-x64-v8.0.3.33.tgz -O - | tar -xz && \
    cp -R /tmp/cuda/NVIDIA_SLA_cuDNN_Support.txt /usr/local/cuda/ && \
    cp -R /tmp/cuda/include/* /usr/local/cuda/include/ && \
    cp -R /tmp/cuda/lib64/* /usr/local/cuda/lib64/ && \
    # Download OpenCV source
    cd /tmp && \
    wget -c https://github.com/opencv/opencv/archive/$OPENCV_VER.tar.gz -O - | tar -xz && \
    mv opencv-$OPENCV_VER opencv && \
    wget -c https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.tar.gz -O - | tar -xz && \
    mv opencv_contrib-$OPENCV_VER opencv_contrib && \
    # Configure
    mkdir -vp /tmp/opencv/build && \
    cd /tmp/opencv/build && \
    /tmp/script/cmake_$TARGETARCH.sh && \
    # Build
    make -j $(($(nproc) / 2 + 1)) && \
    make install && \
    # Cleanup
    cd / && rm -vrf /tmp/* && \
    apt purge -y build-essential cmake wget \
    libatlas-base-dev gfortran && \
    apt autoremove -y && apt autoclean -y && \
    rm -vrf /var/cache/apt/*
