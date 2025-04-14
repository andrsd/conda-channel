#!/bin/bash
set -xe

sedinplace() {
  if [[ $(uname) == Darwin ]]; then
    sed -i "" "$@"
  else
    sed -i"" "$@"
  fi
}

cmake ${CMAKE_ARGS} \
  -DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX};${BUILD_PREFIX}/${HOST}/sysroot" \
  -DCMAKE_PREFIX_PATH=${BUILD_PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_MESSAGE=LAZY \
  -DENABLE_MPI=ON \
  -DENABLE_HDF5=ON \
  -DENABLE_TESTING=OFF \
  -DENABLE_BLASLAPACK=OFF \
  ${SRC_DIR}

make -j${CPU_COUNT}
make install

sedinplace s%${BUILD_PREFIX}%${PREFIX}%g ${PREFIX}/lib/cmake/MOAB/MOABConfig.cmake
sedinplace s%${BUILD_PREFIX}%${PREFIX}%g ${PREFIX}/lib/cmake/MOAB/MOABTargets.cmake

sedinplace s%${SRC_DIR}%%g ${PREFIX}/lib/cmake/MOAB/MOABConfig.cmake
