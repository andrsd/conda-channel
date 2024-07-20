#!/bin/bash

cmake -S . -B build ${CMAKE_ARGS} \
  -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Relase \
  -DBUILD_SHARED_LIBS=ON \
  ${SRC_DIR}

cmake --build build --parallel ${CPU_COUNT}
cmake --build build -- install
