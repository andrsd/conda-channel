#!/bin/bash

if [[ "$target_platform" == osx-* ]]; then
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake -S . -B build \
  ${CMAKE_ARGS} -LAH -G"$CMAKE_GENERATOR" \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel ${CPU_COUNT}
ctest --test-dir build -E 012_cite
cmake --build build -- install
