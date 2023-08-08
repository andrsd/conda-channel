#!/bin/bash

# configure balks if F90 is defined
# with a fatal deprecation message pointing to FC
unset F90 F77

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

unset CPPFLAGS
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS
unset FFLAGS
unset FCFLAGS

# allow argument mismatch in Fortran
# https://github.com/pmodels/mpich/issues/4300
export FFLAGS="$FFLAGS -fallow-argument-mismatch"
export FCFLAGS="$FCFLAGS -fallow-argument-mismatch"

./configure \
  --prefix=$PREFIX \
  --disable-java \
  --with-pm=hydra \
  --with-hwloc=embedded \
  --with-device=ch3:nemesis \
  --disable-opencl \
  --disable-maintainer-mode \
  --disable-dependency-tracking \
  --enable-cxx \
  --enable-fortran

make -j"${CPU_COUNT:-1}"
make install
