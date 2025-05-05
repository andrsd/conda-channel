#!/bin/bash

set -e

. activate "${BUILD_PREFIX}"
cd "${SRC_DIR}"

pushd cctools_build_final
  make install
popd

pushd "${BUILD_PREFIX}"
  # This is packaged in ld64
  rm bin/*-ld
popd
