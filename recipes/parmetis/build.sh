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
  -DGKLIB_PATH=../headers \
  -DSHARED=ON \
  -DMETIS_USE_LONGINDEX=ON \
  ${SRC_DIR}
make install -j${CPU_COUNT}
