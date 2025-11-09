#!/bin/bash

set -o errexit -o pipefail

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Relase \
  ${SRC_DIR}

make -j${CPU_COUNT}
make install
