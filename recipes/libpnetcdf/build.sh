#!/bin/bash
set -xe

export MPICC=${PREFIX}/bin/mpicc
export MPICXX=${PREFIX}/bin/mpic++
export MPIF77=${PREFIX}/bin/mpifort
export MPIF90=${PREFIX}/bin/mpifort

./configure \
  --prefix="${PREFIX}" \
  --with-mpi=${PREFIX} \
  --disable-cxx \
  --enable-fortran \
  --enable-shared \
  --enable-static=no

make -j "${CPU_COUNT}"
make install
