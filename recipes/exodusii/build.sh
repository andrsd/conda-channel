#!/bin/bash

set -x

export CC=mpicc
export CXX=mpic++
export FC=mpifort

CMAKE_BUILD_TYPE=Release

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${BUILD_PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR:STRING="lib" \
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DACCESSDIR:PATH=${PREFIX} \
  -DCMAKE_INSTALL_RPATH:PATH=${PREFIX}/lib \
  -DSeacas_ENABLE_SEACASExodus=ON \
  -DSeacas_ENABLE_SEACASExodus_for=ON \
  -DSeacas_ENABLE_SEACASExoIIv2for32=ON \
  -DSeacas_ENABLE_TESTS=OFF \
  -DTPL_ENABLE_HDF5=ON \
  -DTPL_ENABLE_Netcdf=ON \
  -DTPL_ENABLE_MPI=ON \
  -DTPL_ENABLE_Pamgen=OFF \
  -DTPL_ENABLE_CGNS=OFF \
  -DTPL_ENABLE_Matio=OFF \
  -DSeacas_ENABLE_SEACASExodiff=ON \
  -DSeacas_ENABLE_SEACASExotxt=ON \
  -DSeacas_SKIP_FORTRANCINTERFACE_VERIFY_TEST=ON \
  -DTPL_HDF5_INCLUDE_DIRS=${BUILD_PREFIX}/include \
  -DTPL_HDF5_LIBRARIES=hdf5 \
  -DTPL_Netcdf_INCLUDE_DIRS=${BUILD_PREFIX}/include \
  -DTPL_Netcdf_LIBRARIES=netcdf \
  -DTPL_fmt_INCLUDE_DIRS=${BUILD_PREFIX}/include \
  -DTPL_fmt_LIBRARIES=fmt \
  ${SRC_DIR}
make install -j${CPU_COUNT} ${VERBOSE_CM}
