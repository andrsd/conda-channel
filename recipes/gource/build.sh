#!/usr/bin/env bash
set +x

export FT2_CFLAGS="-I${BUILD_PREFIX}/include/freetype2"
export FT2_LIBS="-L${BUILD_PREFIX}/lib -lfreetype"

export GLEW_CFLAGS="-I${BUILD_PREFIX}/include"
export GLEW_LIBS="-L${BUILD_PREFIX}/lib -lGLEW"

export SDL2_CFLAGS="-I${BUILD_PREFIX}/include/SDL2 -I${BUILD_PREFIX}/include"
export SDL2_LIBS="-L${BUILD_PREFIX}/lib -lSDL2 -lSDL2_image"

export PNG_CFLAGS="-I${BUILD_PREFIX}/include/libpng16 -I${BUILD_PREFIX}/include"
export PNG_LIBS="-L${BUILD_PREFIX}/lib -lpng16"

./configure --prefix=$PREFIX --with-boost-libdir=${BUILD_PREFIX}/lib
make -j${CPU_COUNT}
make install
