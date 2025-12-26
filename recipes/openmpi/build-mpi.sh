#!/bin/bash
set -ex

if [[ "$mpi_type" == "external" ]]; then
  exit 0
fi

# validate POSIX-safety of activate script (no bash-isms)
shellcheck -s sh $RECIPE_DIR/openmpi_activate.sh

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

# unset unused Fortran compiler variables
unset FFLAGS F77 F90 F95

# tweak compiler flags
export LIBRARY_PATH="$PREFIX/lib"
if [[ "$target_platform" == osx-* ]]; then
    if [[ -n "$CONDA_BUILD_SYSROOT" ]]; then
        export CFLAGS="$CFLAGS -isysroot $CONDA_BUILD_SYSROOT"
        export CXXFLAGS="$CXXFLAGS -isysroot $CONDA_BUILD_SYSROOT"
    fi
fi

# tweak wrapper ldflags
wrapper_ldflags=""
if [[ "$target_platform" == linux-* ]]; then
    # allow-shlib-undefined required for dependencies to link against older sysroot
    # avoids undefined
    wrapper_ldflags='-Wl,--allow-shlib-undefined'
fi
if [[ "$target_platform" == osx-* ]]; then
    # rpath required for '@rpath/libmpi.*.dylib' to be found at runtime
    wrapper_ldflags='-Wl,-rpath,${libdir}'
fi

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
    #
    # To regenerate the `cross-gfortran.*.sh` files follow these steps:
    #
    # * Create and activate a conda environment with `gcc=X.Y gfortran`
    #   packages and any other package required to configure openmpi.
    #   $ conda create -n ompi-config gcc=X.Y gfortran
    #   $ conda activate ompi-config
    #
    # * Run openmpi's `./configure` script
    #   $ tar -xf openmpi-X.Y.Z.tar.bz2
    #   $ cd openmpi-X.Y.Z
    #   $ ./configure
    #
    # * Use `grep` to get configure variables out of `config.log`:
    #   $ grep ompi_cv_fortran_ config.log | sed 's/^/export /' >> cross-gfortran.$target_arch.sh
    #   $ grep ompi_cv_real16_  config.log | sed 's/^/export /' >> cross-gfortran.$target_arch.sh
    #
    source $RECIPE_DIR/cross-gfortran.$target_platform.sh
fi

# disable wrapper-runpath for consistency with conda-forge wrt dtags
# openmpi's runpath adds new dtags to compiler wrappers
./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --disable-wrapper-runpath \
            --enable-mpi-fortran \
            --docdir=$PWD/_noinst/doc \
            --mandir=$PWD/_noinst/man \
            --with-mpi-moduledir='${includedir}' \
            --with-wrapper-ldflags="${wrapper_ldflags}" \
            --with-hwloc=$PREFIX \
            --with-libevent=$PREFIX \
            --with-libfabric=$PREFIX \
            --with-pmix=internal \
            --with-prrte=internal \
            --with-zlib=$PREFIX \
            --enable-ipv6

make -j"${CPU_COUNT:-1}"
make install

# do not install unused bundled-prrte dev and doc files
rm -rf $PREFIX/include/prte
rm -rf $PREFIX/include/prte*.h
rm -rf $PREFIX/share/prte/rst

POST_LINK=$PREFIX/bin/.openmpi-post-link.sh
if [ -f $POST_LINK ]; then
    chmod +x $POST_LINK
fi

mkdir -p $PREFIX/etc/conda/activate.d
cp -v $RECIPE_DIR/openmpi_activate.sh $PREFIX/etc/conda/activate.d/
