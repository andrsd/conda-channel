#!/bin/bash
set -x

cmake_args=(
    -DINTSIZE:STRING=64
    -DINSTALL_METIS_HEADERS:BOOL=OFF
    -DSCOTCH_METIS_PREFIX:BOOL=ON
    -DCOMMON_FILE_COMPRESS_GZ:BOOL=ON
    -DBUILD_FORTRAN:BOOL=OFF
    -DENABLE_TESTS:BOOL=OFF
)

if [[ "$target_platform" == osx-* ]]; then
    cmake_args+=(
        -DCOMMON_TIMING_OLD:BOOL=ON
    )
fi

cmake \
    -S ${SRC_DIR} \
    -B build \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    "${cmake_args[@]}"
cmake --build build --parallel ${CPU_COUNT}
cmake --build build -- install
