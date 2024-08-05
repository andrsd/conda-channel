#!/bin/bash
set -x

mkdir build
cd build
cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DKokkos_ENABLE_COMPLEX_ALIGN=OFF \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DKokkos_ENABLE_MPI=ON \
    -DKokkos_ENABLE_HWLOC=ON \
    -DKokkos_ENABLE_SERIAL=ON \
    -DKokkos_ENABLE_LIBDL=OFF \
    -DKokkos_ENABLE_THREADS=ON \
    -DCMAKE_CXX_STANDARD=17 \
    ${SRC_DIR}

make -j${CPU_COUNT}
make install
