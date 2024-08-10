#!/bin/bash
set -x

export CXXFLAGS="`echo $CXXFLAGS | sed 's/-fvisibility-inlines-hidden//'`"

mkdir build
cd build
cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DKokkos_ENABLE_COMPLEX_ALIGN=OFF \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DKokkos_ENABLE_HWLOC=ON \
    -DKokkos_ENABLE_SERIAL=ON \
    -DKokkos_ENABLE_LIBDL=OFF \
    -DKokkos_ENABLE_OPENMP=ON \
    -DCMAKE_CXX_STANDARD=17 \
    ${SRC_DIR}

sedinplace() {
    if [[ $(uname) == Darwin ]]; then
        sed -i "" "$@"
    else
        sed -i"" "$@"
    fi
}

sedinplace s%${BUILD_PREFIX}%${PREFIX}%g temp/kokkos_launch_compiler
sedinplace s%${BUILD_PREFIX}%${PREFIX}%g KokkosConfigCommon.cmake

make -j${CPU_COUNT}
make install
