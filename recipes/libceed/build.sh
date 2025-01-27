#!/bin/bash

set -ex

export FC=$FC
export FFLAGS="$FFLAGS -cpp"

make
if [[ "$target_platform" == linux-* ]]; then
    make prove-all
fi
make install prefix=$PREFIX
