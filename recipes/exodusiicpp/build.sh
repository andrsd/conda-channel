#!/bin/bash

export CXXFLAGS="`echo $CXXFLAGS | sed 's/-fvisibility-inlines-hidden//'`"

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Relase \
  -DEXODUSIICPP_LIBRARY_TYPE=SHARED \
  -DEXODUSIICPP_BUILD_TOOLS=ON \
  ${SRC_DIR}

make -j${CPU_COUNT}
make install
