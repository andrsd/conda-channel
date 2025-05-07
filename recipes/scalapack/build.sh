#!/bin/bash

export CC=mpicc
export CXX=mpic++
export FC=mpifort

# see https://github.com/Reference-ScaLAPACK/scalapack/issues/31
export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"
# Workaround for https://github.com/conda-forge/scalapack-feedstock/pull/30#issuecomment-1061196317
export FFLAGS="${FFLAGS} -fallow-argument-mismatch"

cmake_args=(
    ${CMAKE_ARGS}
    -DCMAKE_PREFIX_PATH=${BUILD_PREFIX}
    -DCMAKE_INSTALL_PREFIX=${PREFIX}
    -DCMAKE_BUILD_TYPE=Release
    -DBUILD_SHARED_LIBS=ON
    -DSCALAPACK_BUILD_TESTS=OFF
)

if [[ "$target_platform" == linux-* ]]; then
    cmake_args+=(
        -DTPL_BLAS_LIBRARIES=openblas
        -DTPL_LAPACK_LIBRARIES=openblas
    )
elif [[ "$target_platform" == osx-* ]]; then
    cmake_args+=(
        -DTPL_BLAS_LIBRARIES=blas
        -DTPL_LAPACK_LIBRARIES=lapack
    )
fi

mkdir build
cd build
cmake "${cmake_args[@]}" ${SRC_DIR}
make install -j${CPU_COUNT}
