#!/bin/bash
set -ex

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${BUILD_PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DNANOFLANN_BUILD_EXAMPLES=OFF \
  -DNANOFLANN_BUILD_TESTS=OFF \
  ${SRC_DIR}

make -j${CPU_COUNT}
make install
