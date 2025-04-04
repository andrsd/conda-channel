#!/bin/bash

export CC=mpicc
export CXX=mpic++
export FC=mpifort

CMAKE_BUILD_TYPE=Release

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${BUILD_PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
  -DBUILD_SHARED_LIBS=ON \
  -DSCALAPACK_BUILD_TESTS=OFF \
  -DLAPACK_LIBRARIES=openblas \
  -DBLAS_LIBRARIES=openblas \
  ${SRC_DIR}
make install -j${CPU_COUNT}
