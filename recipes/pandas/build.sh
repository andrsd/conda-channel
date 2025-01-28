#!/bin/bash
set -ex

export PYTHONUNBUFFERED=1  # [ppc64le]
# Cross-compilation stuff vendored from numpy-feedstock
# necessary for cross-compilation to point to the right env
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
echo "python = '${PREFIX}/bin/python'" >> ${CONDA_PREFIX}/meson_cross_file.txt
$PYTHON -m pip install -vv --no-deps --ignore-installed .
