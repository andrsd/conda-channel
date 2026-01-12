#!/bin/bash
set -ex

# necessary for cross-compilation to point to the right env
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

mkdir builddir

if [[ $target_platform == "osx-arm64" ]]; then
    # cannot properly detect long double format when cross-compiling, see
    # https://github.com/numpy/numpy/pull/24414
    # write to separate cross-file to not interfere with default cross-python activation, c.f.
    # https://github.com/conda-forge/cross-python-feedstock/blob/91d3c9cf/recipe/activate-cross-python.sh#L111-L125
    echo "[properties]"                                 > $SRC_DIR/numpy_cross_file.txt
    echo "longdouble_format = 'IEEE_DOUBLE_LE'"         >> $SRC_DIR/numpy_cross_file.txt
    export MESON_ARGS="$MESON_ARGS --cross-file=$SRC_DIR/numpy_cross_file.txt"
    # see #370 and https://github.com/numpy/numpy/issues/29820
    export CFLAGS="$CFLAGS -DACCELERATE_NEW_LAPACK"
    export CXXFLAGS="$CXXFLAGS -DACCELERATE_NEW_LAPACK"
fi

# -wnx flags mean: --wheel --no-isolation --skip-dependency-check
if [[ "$target_platform" == osx-* ]]; then
  $PYTHON -m build -w -n -x \
      -Cbuilddir=builddir \
      -Csetup-args=-Dblas=accelerate \
      -Csetup-args=-Dlapack=accelerate \
      -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
      || (cat builddir/meson-logs/meson-log.txt && exit 1)
else
  $PYTHON -m build -w -n -x \
      -Cbuilddir=builddir \
      -Csetup-args=-Dblas=openblas \
      -Csetup-args=-Dlapack=openblas \
      -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
      || (cat builddir/meson-logs/meson-log.txt && exit 1)
fi

$PYTHON -m pip install dist/numpy*.whl
