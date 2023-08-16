#!/bin/bash

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DFPROPS_WITH_PYTHON=YES \
  ${SRC_DIR}

make -j${CPU_COUNT}
make install
