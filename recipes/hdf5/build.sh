#!/bin/bash

set -x

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./bin

export CC=mpicc
export CXX=mpic++
export FC=mpifort

./configure \
    --prefix="${PREFIX}" \
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

sedinplace() {
  if [[ $(uname) == Darwin ]]; then
    sed -i "" "$@"
  else
    sed -i"" "$@"
  fi
}


sedinplace "s%${BUILD_PREFIX}%\${prefix}%g" $PREFIX/bin/h5c++
sedinplace "s%${BUILD_PREFIX}%\${prefix}%g" $PREFIX/bin/h5pcc

# strip compiler definitions that can hose up builds using HDF5
sedinplace "s%-DNDEBUG%%g" $PREFIX/bin/h5c++
sedinplace "s%-DNDEBUG%%g" $PREFIX/bin/h5pcc
sedinplace "s%-D_FORTIFY_SOURCE=2%%g" $PREFIX/bin/h5c++
sedinplace "s%-D_FORTIFY_SOURCE=2%%g" $PREFIX/bin/h5pcc
