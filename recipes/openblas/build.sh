#!/bin/bash
set -ex

# Fix ctest not automatically discovering tests
LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,--gc-sections//g")

# See this workaround
# ( https://github.com/xianyi/OpenBLAS/issues/818#issuecomment-207365134 ).
CF="${CFLAGS}"
unset CFLAGS

if [[ "$USE_OPENMP" == "1" ]]; then
    # Run the the fork test
    sed -i.bak 's/test_potrs.o/test_potrs.o test_fork.o/g' utest/Makefile
fi

if [ ! -z "$FFLAGS" ]; then
    export FFLAGS="${FFLAGS/-fopenmp/ }";
fi
export FFLAGS="${FFLAGS} -frecursive"

# Because -Wno-missing-include-dirs does not work with gfortran:
[[ -d "${PREFIX}"/include ]] || mkdir "${PREFIX}"/include
[[ -d "${PREFIX}"/lib ]] || mkdir "${PREFIX}"/lib

# Set CPU Target
if [[ "${target_platform}" == linux-aarch64 ]]; then
  TARGET="ARMV8"
  BINARY="64"
  DYNAMIC_ARCH=1
elif [[ "${target_platform}" == linux-ppc64le ]]; then
  TARGET="POWER8"
  BUILD_BFLOAT16=1
  BINARY="64"
  DYNAMIC_ARCH=1
elif [[ "${target_platform}" == linux-64 ]]; then
  TARGET="PRESCOTT"
  BUILD_BFLOAT16=1
  BINARY="64"
  DYNAMIC_ARCH=1
elif [[ "${target_platform}" == osx-64 ]]; then
  TARGET="CORE2"
  BUILD_BFLOAT16=1
  BINARY="64"
  DYNAMIC_ARCH=1
elif [[ "${target_platform}" == osx-arm64 ]]; then
  TARGET="VORTEX"
  BINARY="64"
  DYNAMIC_ARCH=0
fi

QUIET_MAKE=0
if [[ "$CI" == "travis" ]]; then
  QUIET_MAKE=1
fi

export HOSTCC=$CC_FOR_BUILD

OBJCONV=""
if [[ "${target_platform}" == "osx-arm64" && "${build_platform}" != "osx-arm64" ]]; then
  OBJCONV="OBJCONV=objconv"
fi

if [[ "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
  # We'd like to set CROSS=0 for builds with an emulator in order to run tests,
  # but as of 0.3.29 aarch64/ppc64 run into spurious emulation errors
  CROSS=1
elif [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  CROSS=0
else
  CROSS=1
fi

# see https://github.com/OpenMathLib/OpenBLAS/issues/4017
export OMP_NUM_THREADS=1

# Build all CPU targets and allow dynamic configuration
# Build LAPACK.
# Enable threading. This can be controlled to a certain number by
# setting OPENBLAS_NUM_THREADS before loading the library.
# Tests are run as part of build
make QUIET_MAKE=${QUIET_MAKE} DYNAMIC_ARCH=${DYNAMIC_ARCH} BINARY=${BINARY} NO_LAPACK=0 CFLAGS="${CF}" \
     HOST=${HOST} TARGET=${TARGET} CROSS_SUFFIX="${HOST}-" \
     NO_AFFINITY=1 USE_THREAD=1 NUM_THREADS=128 USE_OPENMP="${USE_OPENMP}" \
     INTERFACE64=${INTERFACE64} SYMBOLSUFFIX=${SYMBOLSUFFIX} ${OBJCONV} CROSS=${CROSS}
make install PREFIX="${PREFIX}" \
     QUIET_MAKE=${QUIET_MAKE} DYNAMIC_ARCH=${DYNAMIC_ARCH} BINARY=${BINARY} NO_LAPACK=0 CFLAGS="${CF}" \
     HOST=${HOST} TARGET=${TARGET} CROSS_SUFFIX="${HOST}-" \
     NO_AFFINITY=1 USE_THREAD=1 NUM_THREADS=128 USE_OPENMP="${USE_OPENMP}" \
     INTERFACE64=${INTERFACE64} SYMBOLSUFFIX=${SYMBOLSUFFIX} ${OBJCONV} CROSS=${CROSS}

if [[ "${target_platform}" == osx-arm64 ]]; then
  TARGET_LOWER=$(echo "$TARGET" | tr '[:upper:]' '[:lower:]')
  ls -alh $PREFIX/lib/libopenblas*
  # Make sure the concrete library is libopenblas.0.dylib and there's a link for
  # libopenblas_vortexp-r${PKG_VERSION}.dylib for backwards compatibility
  rm $PREFIX/lib/libopenblas${SYMBOLSUFFIX}.0.dylib
  mv $PREFIX/lib/libopenblas${SYMBOLSUFFIX}_${TARGET_LOWER}p-r${PKG_VERSION}.dylib $PREFIX/lib/libopenblas${SYMBOLSUFFIX}.0.dylib
  ln -sf $PREFIX/lib/libopenblas${SYMBOLSUFFIX}.0.dylib $PREFIX/lib/libopenblas${SYMBOLSUFFIX}p-r${PKG_VERSION}.dylib
  ln -sf $PREFIX/lib/libopenblas${SYMBOLSUFFIX}.0.dylib $PREFIX/lib/libopenblas${SYMBOLSUFFIX}_vortexp-r${PKG_VERSION}.dylib
  ln -sf $PREFIX/lib/libopenblas${SYMBOLSUFFIX}.0.dylib $PREFIX/lib/libopenblas${SYMBOLSUFFIX}_armv8p-r${PKG_VERSION}.dylib
fi
