#!/bin/bash
set -x

CMAKE_BUILD_TYPE=Release

cmake_args=(
    ${CMAKE_ARGS}
    -DCMAKE_PREFIX_PATH=${BUILD_PREFIX}
    -DCMAKE_INSTALL_PREFIX=${PREFIX}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS=ON
    -DBUILD_STATIC_LIBS=OFF
    -DCMAKE_DISABLE_FIND_PACKAGE_OpenMP=TRUE
    -DUSE_XSDK_DEFAULTS=YES
    -DXSDK_INDEX_SIZE=64
    -DXSDK_ENABLE_Fortran=OFF
    -DTPL_PARMETIS_INCLUDE_DIRS=${BUILD_PREFIX}/include
    -DTPL_PARMETIS_LIBRARIES="${BUILD_PREFIX}/lib/libparmetis${SHLIB_EXT};${BUILD_PREFIX}/lib/libmetis${SHLIB_EXT}"
    -Denable_tests=0
    -Denable_examples=0
    -DBUILD_TESTING=OFF
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

cmake -S ${SRC_DIR} -B build "${cmake_args[@]}"
cmake --build build --target install --parallel ${CPU_COUNT}
