#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.
#
# Python development guide: https://docs.python.org/devguide/

pkgname=singularity
pkgbranch=${VERSION:-development-3.0}
pkgfull=$pkgname-$pkgbranch
pkgrepo=http://github.com/singularityware/singularity

# unpack (clone)
# FIXME: https://github.com/singularityware/singularity/issues/1078
if [ -z "$GOPATH" ] ; then
  echo "GOPATH unset; exit"
  exit 1
fi
mkdir -p $GOPATH/src/github.com/singularityware
cd $GOPATH/src/github.com/singularityware
git clone https://github.com/singularityware/singularity.git
cd singularity
git fetch
git checkout development-3.0

# install dependency.
go get -u -v github.com/golang/dep/cmd/dep
cd $GOPATH/src/github.com/singularityware/singularity
dep ensure -v

# build
cd $GOPATH/src/github.com/singularityware/singularity
rm -rf builddir

namemunge CPATH $INSTALLDIR/include
namemunge LIBRARY_PATH $INSTALLDIR/lib

echo "start mconfig:"
{ time ./mconfig \
  -p $INSTALLDIR \
  -c clang \
  -x clang++ \
; } > mconfig.log 2>&1
echo "done mconfig: $(showrealpath mconfig.log)"

echo "start make:"
cd ./builddir
{ time make ;  } > make.log 2>&1
echo "done make: $(showrealpath make.log)"

echo "start install:"
{ time make install ; } > install.log 2>&1
echo "done install: $(showrealpath install.log)"

# vim: set et nobomb ff=unix fenc=utf8:
