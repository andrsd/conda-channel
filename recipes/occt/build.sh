#!/bin/bash

cmake_args=(
    -DCMAKE_FIND_ROOT_PATH="$PREFIX;$BUILD_PREFIX/$HOST/sysroot"
    -DCMAKE_INSTALL_PREFIX:FILEPATH=$PREFIX
    -DCMAKE_PREFIX_PATH:FILEPATH=$PREFIX
    -D3RDPARTY_DIR:FILEPATH=$PREFIX
    -DUSE_TBB=OFF
    -DCMAKE_BUILD_TYPE="Release"
    -DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF
    -DBUILD_MODULE_Draw=OFF
    -DBUILD_MODULE_Visualization=OFF
    -DUSE_VTK=OFF
    -DUSE_RAPIDJSON=ON
    -DUSE_FREEIMAGE=OFF
    -DUSE_FREETYPE=OFF
)

cmake -S . -B build "${cmake_args[@]}"

cmake --build build --parallel ${CPU_COUNT} -- install
