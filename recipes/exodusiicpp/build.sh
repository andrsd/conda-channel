#!/bin/bash

export CXXFLAGS="`echo $CXXFLAGS | sed 's/-fvisibility-inlines-hidden//'`"

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Relase \
  -DEXODUSIICPP_LIBRARY_TYPE=SHARED \
  ${SRC_DIR}

make -j${CPU_COUNT}
make install
