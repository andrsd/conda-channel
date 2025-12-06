#!/bin/bash

cmake \
    -S ${SRC_DIR} \
    -B build \
    ${CMAKE_ARGS} \
    -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Relase \
    -DBUILD_SHARED_LIBS=ON
cmake --build build
cmake --build build -- install
