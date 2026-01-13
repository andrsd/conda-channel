#!/bin/bash
set -ex

mkdir builddir

# HACK: extend $CONDA_PREFIX/meson_cross_file that's created in
# https://github.com/conda-forge/ctng-compiler-activation-feedstock/blob/main/recipe/activate-gcc.sh
# https://github.com/conda-forge/clang-compiler-activation-feedstock/blob/main/recipe/activate-clang.sh
# to use host python; requires that [binaries] section is last in meson_cross_file
echo "python = '${PREFIX}/bin/python'" >> ${CONDA_PREFIX}/meson_cross_file.txt

# -wnx flags mean: --wheel --no-isolation --skip-dependency-check
if [[ "$target_platform" == osx-* ]]; then
    $PYTHON -m build -w -n -x \
        -Cbuilddir=builddir \
        -Cinstall-args=--tags=runtime,python-runtime,devel \
        -Csetup-args=-Dblas=accelerate \
        -Csetup-args=-Dlapack=accelerate \
        -Csetup-args=-Duse-g77-abi=true \
        -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
        || (cat builddir/meson-logs/meson-log.txt && exit 1)
else
    $PYTHON -m build -w -n -x \
        -Cbuilddir=builddir \
        -Cinstall-args=--tags=runtime,python-runtime,devel \
        -Csetup-args=-Dblas=openblas \
        -Csetup-args=-Dlapack=openblas \
        -Csetup-args=-Duse-g77-abi=true \
        -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
        || (cat builddir/meson-logs/meson-log.txt && exit 1)
fi