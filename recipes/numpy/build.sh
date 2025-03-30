#!/bin/bash
set -ex

# necessary for cross-compilation to point to the right env
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

mkdir builddir

# HACK: extend $CONDA_PREFIX/meson_cross_file that's created in
# https://github.com/conda-forge/ctng-compiler-activation-feedstock/blob/main/recipe/activate-gcc.sh
# https://github.com/conda-forge/clang-compiler-activation-feedstock/blob/main/recipe/activate-clang.sh
# to use host python; requires that [binaries] section is last in meson_cross_file
echo "python = '${PREFIX}/bin/python'" >> ${CONDA_PREFIX}/meson_cross_file.txt

if [[ $target_platform == "osx-arm64" ]]; then
    # currently cannot properly detect long double format
    # on osx-arm64 when cross-compiling in QEMU, see
    # https://github.com/numpy/numpy/pull/24414
    echo "[properties]" >> ${CONDA_PREFIX}/meson_cross_file.txt
    echo "longdouble_format = 'IEEE_DOUBLE_LE'" >> ${CONDA_PREFIX}/meson_cross_file.txt
fi

if [[ -z ${var+x} ]] ; then
    export MESON_ARGS="--buildtype release --prefix=$PREFIX -Dlibdir=lib"
fi

# meson-python already sets up a -Dbuildtype=release argument to meson, so
# we need to strip --buildtype out of MESON_ARGS or fail due to redundancy
MESON_ARGS_REDUCED="$(echo $MESON_ARGS | sed 's/--buildtype release //g')"

# -wnx flags mean: --wheel --no-isolation --skip-dependency-check
if [[ "$target_platform" == osx-* ]]; then
  $PYTHON -m build -w -n -x \
      -Cbuilddir=builddir \
      -Csetup-args=-Dblas=accelerate \
      -Csetup-args=-Dlapack=accelerate \
      -Csetup-args=${MESON_ARGS_REDUCED// / -Csetup-args=} \
      || (cat builddir/meson-logs/meson-log.txt && exit 1)
else
  $PYTHON -m build -w -n -x \
      -Cbuilddir=builddir \
      -Csetup-args=-Dblas=openblas \
      -Csetup-args=-Dlapack=openblas \
      -Csetup-args=${MESON_ARGS_REDUCED// / -Csetup-args=} \
      || (cat builddir/meson-logs/meson-log.txt && exit 1)
fi

pip install dist/numpy*.whl
