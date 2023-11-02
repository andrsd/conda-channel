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
  --enable-erange-fill \
  --enable-zero-length-coord-bound \
  --disable-byterange \
  --disable-hdf4 \
  --disable-dap \
  --disable-dap-remote-tests \
  --disable-dynamic-loading \
  --disable-testsets \
  --disable-examples

make -j${CPU_COUNT}
make install
