#!/bin/bash

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DEXODUSIICPP_LIBRARY_TYPE=STATIC \
  -DEXODUSIICPP_BUILD_TOOLS=OFF \
  -DGMSHPARSERCPP_LIBRARY_TYPE=STATIC \
  ${SRC_DIR}

# NOTE: cannot do parallel build, dependencies are not correct in gmshparsercpp
make
make install
