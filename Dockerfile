FROM ros:melodic-ros-base-bionic

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    wget git build-essential \
    libtool autoconf unzip python3-pybind11

RUN wget https://cmake.org/files/v3.22/cmake-3.22.6.tar.gz \
    && tar -xzvf cmake-3.22.6.tar.gz \
    && cd cmake-3.22.6 \
    && ./bootstrap \
    && make -j && make install

RUN wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.3.tar.gz \
    && tar -zxvf yaml-cpp-0.6.3.tar.gz && rm yaml-cpp-0.6.3.tar.gz
RUN cd yaml-cpp-yaml-cpp-0.6.3 && mkdir build && cd build \
    && cmake [-G generator] [-DYAML_BUILD_SHARED_LIBS=ON] .. \
    && make && make install 

RUN apt-get install -y --no-install-recommends python-catkin-tools \
    ros-melodic-ecl-threads \
    ros-melodic-jsk-recognition-msgs \
    ros-melodic-jsk-visualization \
    ros-melodic-velodyne-msgs

RUN wget https://github.com/isl-org/Open3D/archive/refs/tags/v0.12.0.tar.gz \
    && tar -zxvf v0.12.0.tar.gz && rm v0.12.0.tar.gz

RUN cd Open3D-0.12.0 \
    && util/install_deps_ubuntu.sh assume-yes \
    && mkdir build && cd build \
    && cmake \
        -DBUILD_SHARED_LIBS=ON \
        -DPYTHON_EXECUTABLE=$(which python3) \
        -DBUILD_CUDA_MODULE=ON \
        -DGLIBCXX_USE_CXX11_ABI=ON \
        -DBUILD_LIBREALSENSE=ON  \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        ../ \
    && make -j && make install 

RUN mkdir -p /tloam_ws/src && cd /tloam_ws \
     && catkin init \
     && catkin config --merge-devel \
     && catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release \ 
     && cd src \
     && git clone https://github.com/zhoupengwei/tloam.git \
     && catkin build
