#!/bin/bash

if [[ "$target_platform" == osx-* ]]; then
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

mkdir build && cd build
cmake ${CMAKE_ARGS} -LAH -G"$CMAKE_GENERATOR" \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  ..

make -j${CPU_COUNT}
make install
