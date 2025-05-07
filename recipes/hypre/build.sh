#!/bin/bash
set -x

cmake_args=(
    ${CMAKE_ARGS}
    -DCMAKE_INSTALL_PREFIX="${PREFIX}"
    -DCMAKE_BUILD_TYPE=Release
    -DHYPRE_ENABLE_SHARED=ON
    -DBUILD_SHARED_LIBS=ON
    -DHYPRE_ENABLE_HYPRE_BLAS=OFF
    -DHYPRE_ENABLE_HYPRE_LAPACK=OFF
    -DHYPRE_WITH_OPENMP=OFF
    -DHYPRE_ENABLE_BIGINT=ON
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
cmake "${cmake_args[@]}" ${SRC_DIR}/src
make -j${CPU_COUNT}
make install
