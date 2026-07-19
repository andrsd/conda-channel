#!/bin/bash
set -x

sedinplace() {
  if [[ $(uname) == Darwin ]]; then
    sed -i "" "$@"
  else
    sed -i"" "$@"
  fi
}

CMAKE_BUILD_TYPE=Release

mkdir build
cd build
cmake ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${BUILD_PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
  -DWITH_MPI=ON \
  -DWITH_KOKKOS=OFF \
  ${SRC_DIR}
make install -j${CPU_COUNT}

sedinplace s%${BUILD_PREFIX}%${PREFIX}%g ${PREFIX}/share/cmake/caliper/caliper-targets.cmake
