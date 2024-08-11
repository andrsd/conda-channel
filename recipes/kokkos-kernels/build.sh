#!/bin/bash
set -x

export CXXFLAGS="`echo $CXXFLAGS | sed 's/-fvisibility-inlines-hidden//'`"

mkdir build
cd build
cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_TESTING=OFF \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    ${SRC_DIR}

make -j${CPU_COUNT}
make install
