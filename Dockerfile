FROM ros:melodic-ros-base-bionic

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget git build-essential sed \
    libtool autoconf automake unzip \
    python-catkin-tools python3-pip \
    ros-melodic-ecl-threads \
    ros-melodic-jsk-recognition-msgs \
    ros-melodic-jsk-visualization \
    ros-melodic-velodyne-msgs \
    libgoogle-glog-dev libgflags-dev

RUN pip3 install catkin_pkg

RUN wget https://cmake.org/files/v3.22/cmake-3.22.6.tar.gz \
    && tar -xzvf cmake-3.22.6.tar.gz && rm cmake-3.22.6.tar.gz \
    && cd cmake-3.22.6 \
    && ./bootstrap \
    && make && make install

RUN wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.3.tar.gz \
    && tar -zxvf yaml-cpp-0.6.3.tar.gz && rm yaml-cpp-0.6.3.tar.gz \
    && cd yaml-cpp-yaml-cpp-0.6.3 && mkdir build && cd build \
    && cmake [-G generator] [-DYAML_BUILD_SHARED_LIBS=ON] .. \
    && make && make install

# build Open3D from source, it is slow
# RUN git clone --recursive --depth 1 --branch v0.15.0 https://github.com/isl-org/Open3D.git

# RUN cd Open3D \
#     && util/install_deps_ubuntu.sh assume-yes \
#     && mkdir build && cd build \
#     && cmake \
#         -DBUILD_SHARED_LIBS=ON \
#         -DBUILD_LIBREALSENSE=ON  \
#         -DCMAKE_BUILD_TYPE=Release \
#         -DCMAKE_INSTALL_PREFIX=/usr/local \
#         ../ \
#     && make && make install

# Open3D v0.15.1 released binary
RUN wget https://github.com/isl-org/Open3D/releases/download/v0.15.1/open3d-devel-linux-x86_64-cxx11-abi-0.15.1.tar.xz \
    && tar -xf open3d-devel-linux-x86_64-cxx11-abi-0.15.1.tar.xz \
    && rm open3d-devel-linux-x86_64-cxx11-abi-0.15.1.tar.xz

RUN cd open3d-devel-linux-x86_64-cxx11-abi-0.15.1 \
    && cp -r include/open3d /usr/local/include/ \
    && cp lib/libOpen3D.so /usr/local/lib/ \
    && mkdir -p /usr/local/lib/cmake/Open3D \
    && cp -r lib/cmake/Open3D/* /usr/local/lib/cmake/Open3D/ \
    && ldconfig

RUN wget http://ceres-solver.org/ceres-solver-2.0.0.tar.gz \
    && tar -xf ceres-solver-2.0.0.tar.gz \
    && rm ceres-solver-2.0.0.tar.gz
RUN cd ceres-solver-2.0.0 && mkdir build && cd build && cmake ../ && make && make install

RUN rm -rf cmake-3.22.6 yaml-cpp-yaml-cpp-0.6.3 open3d-devel-linux-x86_64-cxx11-abi-0.15.1 ceres-solver-2.0.0

RUN mkdir -p /tloam_ws/src && cd /tloam_ws \
     && catkin init \
     && catkin config --merge-devel \
     && catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release \ 
     && cd src \
     && git clone https://github.com/zhoupengwei/tloam.git

# this will fail, check https://github.com/zhoupengwei/tloam/issues/8 and https://github.com/zhoupengwei/tloam/issues/9
# RUN cd /tloam_ws/src && catkin build
