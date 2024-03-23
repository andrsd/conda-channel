#!/bin/sh

mkdir build && cd build

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" || "$MESON_ARGS" == "" ]]; then
  meson --prefix=$PREFIX --libdir=$PREFIX/lib --buildtype=release -Dtests=false ..
else
  meson ${MESON_ARGS} -Dtests=false ..
fi

ninja install
