#!/bin/bash
set -ex

cp $RECIPE_DIR/files/Makefile.inc ${SRC_DIR}/src/Makefile.inc

export CFLAGS="${CFLAGS} -O3 -fPIC -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -Drestrict=\"restrict\" -DINTSIZE64 -DSCOTCH_METIS_PREFIX -DSCOTCH_RENAME -DINTSIZE64 -DSCOTCH_METIS_PREFIX"

if [[ "$(uname)" == "Darwin" ]] ; then
  export CFLAGS="${CFLAGS} -DCOMMON_TIMING_OLD -DCOMMON_OS_MACOS"
fi

export LDFLAGS="${LDFLAGS} -lz -lm"

if [[ "$(uname)" == "Linux" ]] ; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi


# Scotch has a file identical to one in ParMETIS, remove it so ParMETIS will not use it by mistake
rm -f ${SRC_DIR}/include/parmetis.h
# This would only be produced if "make scotch" was invoked, but try to remove it anyway in case someone was messing
# with it
rm -f ${SRC_DIR}/include/metis.h

cd ${SRC_DIR}/src
make ptesmumps esmumps
make prefix=${PREFIX} install
