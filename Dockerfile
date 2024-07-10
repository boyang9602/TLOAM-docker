FROM ros:melodic-ros-base-bionic

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget git build-essential sed \
    libtool autoconf automake unzip \
    python-catkin-tools \
    ros-melodic-ecl-threads \
    ros-melodic-jsk-recognition-msgs \
    ros-melodic-jsk-visualization \
    ros-melodic-velodyne-msgs

RUN wget https://cmake.org/files/v3.22/cmake-3.22.6.tar.gz \
    && tar -xzvf cmake-3.22.6.tar.gz && rm cmake-3.22.6.tar.gz \
    && cd cmake-3.22.6 \
    && ./bootstrap \
    && make && make install

# RUN wget https://cmake.org/files/v3.18/cmake-3.18.6.tar.gz \
#     && tar -xzvf cmake-3.18.6.tar.gz && rm cmake-3.18.6.tar.gz \
#     && cd cmake-3.18.6 \
#     && ./bootstrap \
#     && make && make install

RUN wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.3.tar.gz \
    && tar -zxvf yaml-cpp-0.6.3.tar.gz && rm yaml-cpp-0.6.3.tar.gz \
    && cd yaml-cpp-yaml-cpp-0.6.3 && mkdir build && cd build \
    && cmake [-G generator] [-DYAML_BUILD_SHARED_LIBS=ON] .. \
    && make && make install

RUN git clone --recursive --depth 1 --branch v0.15.0 https://github.com/isl-org/Open3D.git

# RUN sed sed -i 's/junha-l/facebookresearch/g' Open3D/3rdparty/faiss/faiss_build.cmake

RUN cd Open3D \
    && util/install_deps_ubuntu.sh assume-yes \
    && mkdir build && cd build \
    && cmake \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_LIBREALSENSE=ON  \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        ../ \
    && make && make install

RUN mkdir -p /tloam_ws/src && cd /tloam_ws \
     && catkin init \
     && catkin config --merge-devel \
     && catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release \ 
     && cd src \
     && git clone https://github.com/zhoupengwei/tloam.git \
     && catkin build
