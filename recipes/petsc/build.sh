#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

export PETSC_DIR=$SRC_DIR
export PETSC_ARCH=arch-conda-c-opt

unset F90
unset F77
unset CXX

# scrub debug-prefix-map args, which cause problems in pkg-config
export CFLAGS=$(echo ${CFLAGS:-} | sed -E 's@\-fdebug\-prefix\-map[^ ]*@@g')
export CXXFLAGS=$(echo ${CXXFLAGS:-} | sed -E 's@\-fdebug\-prefix\-map[^ ]*@@g')
export FFLAGS=$(echo ${FFLAGS:-} | sed -E 's@\-fdebug\-prefix\-map[^ ]*@@g')

if [[ $mpi == "openmpi" ]]; then
  export LIBS="-Wl,-rpath,$PREFIX/lib -lmpi_mpifh -lgfortran"
  export OMPI_MCA_plm=isolated
  export OMPI_MCA_rmaps_base_oversubscribe=yes
  export OMPI_MCA_btl_vader_single_copy_mechanism=none

  export OMPI_CC=$CC
  export OPAL_PREFIX=$PREFIX
elif [[ $mpi == "mpich" ]]; then
  export HYDRA_LAUNCHER=fork
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  extra_opts="--with-batch"
fi

python ./configure \
  AR="${AR:-ar}" \
  CC="mpicc" \
  CXX="mpicxx" \
  CFLAGS="$CFLAGS" \
  CPPFLAGS="$CPPFLAGS" \
  CXXFLAGS="$CXXFLAGS" \
  LDFLAGS="$LDFLAGS" \
  LIBS="$LIBS" \
  --COPTFLAGS=-O3 \
  --CXXOPTFLAGS=-O3 \
  --with-fc=0 \
  --with-debugging=0 \
  --with-64-bit-indices \
  --with-yaml=0 \
  --with-hdf5=1 \
  --with-hwloc=1 \
  --with-mpi=1 \
  --with-shared-libraries \
  --with-ssl=0 \
  --with-exodusii=1 \
  --with-netcdf=1 \
  --with-pnetcdf=1 \
  --with-ptscotch=1 \
  --with-metis=1 \
  --with-parmetis=1 \
  --with-hypre=1 \
  --with-zlib=1 \
  --with-x=0 \
  --with-pic=1 \
  --with-openmp=0 \
  $extra_opts \
  --prefix=$PREFIX || (exit 1)

# Verify that gcc_ext isn't linked
for f in $PETSC_ARCH/lib/petsc/conf/petscvariables $PETSC_ARCH/lib/pkgconfig/PETSc.pc; do
  if grep gcc_ext $f; then
    echo "gcc_ext found in $f"
    exit 1
  fi
done

sedinplace() {
  if [[ $(uname) == Darwin ]]; then
    sed -i "" "$@"
  else
    sed -i"" "$@"
  fi
}

# Remove abspath of ${BUILD_PREFIX}/bin/python
sedinplace "s%${BUILD_PREFIX}/bin/python%python%g" $PETSC_ARCH/include/petscconf.h
sedinplace "s%${BUILD_PREFIX}/bin/python%python%g" $PETSC_ARCH/lib/petsc/conf/petscvariables
sedinplace "s%${BUILD_PREFIX}/bin/python%/usr/bin/env python%g" $PETSC_ARCH/lib/petsc/conf/reconfigure-arch-conda-c-opt.py

# Replace abspath of ${PETSC_DIR} and ${BUILD_PREFIX} with ${PREFIX}
for path in $PETSC_DIR $BUILD_PREFIX; do
    for f in $(grep -l "${path}" $PETSC_ARCH/include/petsc*.h); do
        echo "Fixing ${path} in $f"
        sedinplace s%$path%\${PREFIX}%g $f
    done
done

make MAKE_NP=${CPU_COUNT}

make install

# Remove unneeded files
rm -f ${PREFIX}/lib/petsc/conf/configure-hash
find $PREFIX/lib/petsc -name '*.pyc' -delete

# Replace ${BUILD_PREFIX} after installation,
# otherwise 'make install' above may fail
for f in $(grep -l "${BUILD_PREFIX}" -R "${PREFIX}/lib/petsc"); do
  echo "Fixing ${BUILD_PREFIX} in $f"
  sedinplace s%${BUILD_PREFIX}%${PREFIX}%g $f
done

echo "Removing example files"
du -hs $PREFIX/share/petsc/examples/src
rm -fr $PREFIX/share/petsc/examples/src
echo "Removing data files"
du -hs $PREFIX/share/petsc/datafiles/*
rm -fr $PREFIX/share/petsc/datafiles

#
mkdir -p "${PREFIX}/etc/conda/activate.d" "${PREFIX}/etc/conda/deactivate.d"
cat <<EOF > "${PREFIX}/etc/conda/activate.d/activate_${PKG_NAME}.sh"
export PETSC_DIR=${PREFIX}
EOF
cat <<EOF > "${PREFIX}/etc/conda/deactivate.d/deactivate_${PKG_NAME}.sh"
unset PETSC_DIR
EOF
