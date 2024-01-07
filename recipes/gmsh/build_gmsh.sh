#!/bin/bash
# see http://conda.pydata.org/docs/build.html for hacking instructions.

if [[ "$c_compiler" == "gcc" ]]; then
  export PATH="${PATH}:${BUILD_PREFIX}/${HOST}/sysroot/usr/lib:${BUILD_PREFIX}/${HOST}/sysroot/usr/include"
fi

cmake -S . -B build \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DENABLE_BUILD_DYNAMIC=ON \
    -DENABLE_BUILD_SHARED=ON \
    -DENABLE_OS_SPECIFIC_INSTALL=OFF \
    -DENABLE_FLTK=$USE_FLTK \
    -DGMSH_RELEASE=1 \
    -DENABLE_TOUCHBAR=OFF \
    -DENABLE_CAIRO=$USE_CAIRO \
    -DENABLE_WRAP_PYTHON=ON

cmake --build build --parallel ${CPU_COUNT} -- install

rm -f ${PREFIX}/lib/gmsh.py
# vim: set ai et nu:
