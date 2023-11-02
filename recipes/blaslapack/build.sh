#!/bin/sh

set -e

mkdir build
cd build

mkdir -p ${PREFIX}/include

if [[ "$target_platform" == linux-* ]]; then
    # workaround a binutils bug
    export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,$(pwd)/lib"
    export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,--as-needed//g")
fi

if [[ "$target_platform" == osx-* ]]; then
    export SDKROOT="${CONDA_BUILD_SYSROOT}"
    export CFLAGS="${CFLAGS} -isysroot ${CONDA_BUILD_SYSROOT}"
    export FFLAGS="${FFLAGS} -isysroot ${CONDA_BUILD_SYSROOT}"
    export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,-dead_strip_dylibs//g")
fi

export LDFLAGS="$LDFLAGS -fno-optimize-sibling-calls"
export FFLAGS="$FFLAGS -fno-optimize-sibling-calls"

# CMAKE_INSTALL_LIBDIR="lib" suppresses CentOS default of lib64 (conda expects lib)

cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR="lib" \
  -DBUILD_TESTING=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DLAPACKE=ON \
  -DCBLAS=ON \
  -DBUILD_DEPRECATED=ON \
  ${CMAKE_ARGS} ..

make -j${CPU_COUNT}
make install


if [[ "${target_platform}" == osx-* ]]; then
    for lib in blas cblas lapack lapacke; do
        mv $PREFIX/lib/lib$lib.dylib $PREFIX/lib/lib$lib.$PKG_VERSION.dylib
        install_name_tool -id $PREFIX/lib/lib$lib.3.dylib $PREFIX/lib/lib$lib.$PKG_VERSION.dylib
        ln -s  $PREFIX/lib/lib$lib.$PKG_VERSION.dylib $PREFIX/lib/lib$lib.dylib
        ln -s  $PREFIX/lib/lib$lib.$PKG_VERSION.dylib $PREFIX/lib/lib$lib.3.dylib
    done
fi
