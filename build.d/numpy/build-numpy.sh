#!/bin/bash -x
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=numpy
pkgbranch=${VERSION:-master}

# unpack (clone / pull)
syncgit https://github.com/numpy $pkgname $pkgbranch

# prepare files for building.
PYTHON=$INSTALLDIR/bin/python3
rm -f site.cfg
if [ $(uname) == Darwin ] ; then
  echo "Darwin"
  cat > site.cfg << EOF
# Use OpenBLAS (homebrew install) with Numpy, since as of today (20210211)
# accelerate backend has a bug with numpy:
# https://github.com/numpy/numpy/issues/15947
[openblas]
libraries = openblas
library_dirs = /usr/local/opt/openblas/lib
include_dirs = /usr/locla/opt/openblas/include
runtime_library_dirs = /usr/local/opt/openblas/lib
EOF
elif [ $(uname) == Linux ] ; then
  cat > site.cfg << EOF
[atlas]
library_dirs = $INSTALLDIR/lib:/usr/lib:/usr/local/lib
include_dirs = $INSTALLDIR/include:$INSTALLDIR/include/atlas:/usr/lib:/usr/local/include
atlas_libs = lapack, f77blas, cblas, atlas
EOF
fi

rm -f setup.cfg
cat >> setup.cfg << EOF
# See the docstring in versioneer.py for instructions. Note that you must
# re-run 'versioneer.py setup' after changing this section, and commit the
# resulting files.

[versioneer]
VCS = git
style = pep440
versionfile_source = numpy/_version.py
versionfile_build = numpy/_version.py
tag_prefix = v
parentdir_prefix = numpy-

[config_fc]
fcompiler = gfortran
EOF

buildcmd build.log $PYTHON setup.py build -j $NP
buildcmd install.log $PYTHON setup.py install --old-and-unmanageable

# Check lapack version.
# https://stackoverflow.com/a/19350234
$PYTHON -c "import numpy as np ; np.show_config()"

# vim: set et nobomb ff=unix fenc=utf8:
