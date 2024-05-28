#!/bin/bash

export CC=mpicc
export CXX=mpic++
export FC=mpifort

./configure \
  --prefix="${PREFIX}" \
  --enable-shared=yes \
  --enable-static=yes \
  --enable-netcdf-4 \
  --enable-pnetcdf \
  --disable-dap \
  --disable-dynamic-loading \
  --disable-libxml2 \
  --disable-byterange \
  --disable-hdf4 \
  --disable-dap-remote-tests \
  --disable-testsets \
  --disable-examples

make -j${CPU_COUNT}
make install
