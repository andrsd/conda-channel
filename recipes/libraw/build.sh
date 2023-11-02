#!/bin/bash

cd libraw
autoreconf --install
./configure --prefix="${PREFIX}" --enable-openmp=yes
make -j${CPU_COUNT}
make install
