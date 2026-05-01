#!/usr/bin/env bash

cmake -B build \
    ${CMAKE_ARGS} \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DBUILD_SHARED_LIBS=ON \
    -DYAML_BUILD_SHARED_LIBS=ON \
    -DYAML_CPP_BUILD_TESTS=OFF \
    ${SRC_DIR}

cmake --build build --parallel ${CPU_COUNT}
cmake --build build -- install
