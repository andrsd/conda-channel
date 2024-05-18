#!/bin/bash

cmake -S . -B build ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_TESTING=OFF \
  -DENABLE_CUDA=OFF \
  -DENABLE_OPENCL=ON \
  -DENABLE_OPENMP=OFF
cmake --build build --parallel ${CPU_COUNT}
cmake --build build -- install
