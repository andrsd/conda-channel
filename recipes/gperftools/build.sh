#!/bin/bash

set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ $(uname) == Darwin ]]; then
  export CFLAGS="$CFLAGS -D_XOPEN_SOURCE"

  ./configure  --prefix $PREFIX   \
    --disable-debugalloc          \
    --disable-libunwind
  make -j${CPU_COUNT}
  make install
else
  ./configure  --prefix $PREFIX --enable-libunwind --enable-frame-pointers
  make -j${CPU_COUNT}

  if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
    make check
  fi

  make install
fi
