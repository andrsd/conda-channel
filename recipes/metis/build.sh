#!/bin/bash

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DGKLIB_PATH=../GKlib \
  -DGKRAND=ON \
  -DSHARED=ON \
  -DMETIS_USE_LONGINDEX=1 \
  ${SRC_DIR}
make install -j${CPU_COUNT}
