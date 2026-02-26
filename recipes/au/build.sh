#!/bin/bash

mkdir build-dir
cd build-dir
cmake ${CMAKE_ARGS} \
  -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DAU_ENABLE_TESTING=OFF \
  ${SRC_DIR}

make install
