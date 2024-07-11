# TLOAM dockerfile
This project is to provide a dockerfile to build [tloam](https://github.com/zhoupengwei/tloam). 

Original TLOAM uses Open3D v0.12. However, it is too old and some dependencies are unavailable and or hard to find. For example, urls of `faiss` and `mkl` specified in Open3D v0.12 do not work anymore. 
I just installed released Open3D v0.15 binary.  
Other [depdencies](https://github.com/zhoupengwei/tloam?tab=readme-ov-file#dependency) use the exact same version specified in the [tloam](https://github.com/zhoupengwei/tloam?tab=readme-ov-file#dependency). 

## Current progress
1. Dependencies are installed successfully. 
2. Docker issue. Sometimes `docker build .` will use all CPUs and crash the server. A temporary solution is by limiting the cpu usage, for example, `docker build --tag loam:tloam --cpuset-cpus="0-8" .` 
3. Building errors of tloam,  
    a. check https://github.com/zhoupengwei/tloam/issues/8 and https://github.com/zhoupengwei/tloam/issues/9  
    b. there are some issues in cmake/googletest.cmake