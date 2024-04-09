#!/bin/bash

if [[ "$target_platform" == osx-* ]]
then
  # force the use of Apple compiler
  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++
  unset FC
  CONF_OPTS=(
    "-DENABLE_METAL=ON"
    "-DENABLE_OPENCL=ON"
    "-DENABLE_OPENMP=OFF"
    "-DENABLE_DPCPP=OFF"
    "-DENABLE_CUDA=OFF"
    "-DENABLE_HIP=OFF"
  )
elif [[ "$target_platform" == linux-* ]]
then
  CONF_OPTS=(
    "-DENABLE_METAL=OFF"
    "-DENABLE_OPENCL=ON"
    "-DENABLE_OPENMP=ON"
    "-DENABLE_DPCPP=OFF"
    "-DENABLE_CUDA=OFF"
    "-DENABLE_HIP=OFF"
  )
fi

cmake -S ${SRC_DIR} -B build \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_FORTRAN=OFF \
  -DENABLE_TESTS=OFF \
  -DENABLE_EXAMPLES=OFF \
  ${CONF_OPTS[@]}

cmake --build build --parallel ${CPU_COUNT}
cmake --build build -- install
