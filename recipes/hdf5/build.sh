#!/bin/bash

set -x

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./bin

export CC=mpicc
export CXX=mpic++
export FC=mpifort

./configure --prefix="${PREFIX}" \
            --enable-parallel \
            --with-pic \
            --host="${HOST}" \
            --build="${BUILD}" \
            --with-zlib="${BUILD_PREFIX}" \
            --with-pthread=yes \
            --with-default-plugindir="${PREFIX}/lib/hdf5/plugin" \
            --enable-build-mode=production \
            --enable-using-memchecker \
            --enable-shared=yes \
            --enable-static=no \
            --enable-ros3-vfd \
            --enable-tests=no \
            --enable-cxx \
            --enable-unsupported

make -j "${CPU_COUNT}" ${VERBOSE_AT}
make install
