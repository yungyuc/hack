#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download lapack.
lapackname=lapack
lapackver=${VERSION:-3.7.0}
lapackfull=$lapackname-$lapackver
lapackloc=$YHDL/$lapackfull.tgz
lapackurl=http://www.netlib.org/$lapackname/$lapackname-$lapackver.tgz
download $lapackloc $lapackurl 697bb8d67c7d336a0f339cc9dd0fa72f

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
rm -rf $lapackfull
tar xf $lapackloc
mkdir -p $lapackfull/build
cd $lapackfull/build

# build.
{ time cmake \
  -DCMAKE_PREFIX_PATH=$INSTALLDIR \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_Fortran_FLAGS="-fPIC -O3" \
  .. ; } > cmake.log 2>&1
{ make -j $NP VERBOSE=1 ; } > make.log 2>&1
{ make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
