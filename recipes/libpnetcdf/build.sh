#!/bin/bash

export CC=mpicc
export CXX=mpic++
export FC=mpifort

./configure \
  --prefix="${PREFIX}" \
  --disable-cxx \
  --enable-fortran \
  --enable-shared

make -j "${CPU_COUNT}"
make install
