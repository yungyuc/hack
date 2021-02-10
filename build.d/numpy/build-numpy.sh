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
  cat > site.cfg << EOF
[atlas]
library_dirs = /usr/lib:/usr/local/lib
include_dirs = /usr/lib:/usr/local/include
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

# How to check numpy atlas status: http://stackoverflow.com/a/23325759/1805420:
# python -c "import numpy.distutils.system_info as si; si.get_info('atlas', 2)"
cd $YHROOT
mkdir -p $YHROOT/tmp
$PYTHON -c \
  "import numpy.distutils.system_info as si; si.get_info('atlas', 2)" \
  > $YHROOT/tmp/atlas_status.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
