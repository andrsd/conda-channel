#!/bin/bash
set -ex

cp $RECIPE_DIR/files/Makefile.conda.PAR ./Makefile.inc

export FFLAGS="${FFLAGS} -fallow-argument-mismatch"
if [[ "$target_platform" == linux-* || "$target_platform" == "osx-arm64"  ]]
 then
   # Workaround for https://github.com/conda-forge/scalapack-feedstock/pull/30#issuecomment-1061196317
   # As of March 2022, on macOS (Intel) gfortran 9 is still used
   export OMPI_FCFLAGS=${FFLAGS}
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # This is only used by open-mpi's mpicc
  # ignored in other cases
  export OMPI_CC=$CC
  export OMPI_CXX=$CXX
  export OMPI_FC=$FC
  export OPAL_PREFIX=$PREFIX
fi

if [[ "$(uname)" == "Darwin" ]]; then
  export SONAME="-Wl,-install_name,@rpath/"
  export LDFLAGS="${LDFLAGS} -headerpad_max_install_names"
else
  export SONAME="-Wl,-soname,"
fi

export CC=mpicc
export FC=mpifort

make allshared

cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib
