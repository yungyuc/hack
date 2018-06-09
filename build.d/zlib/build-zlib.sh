#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download netcdf.
pkgname=zlib
pkgver=1.2.11
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.xz
pkgurl=https://zlib.net/$pkgfull.tar.gz
download $pkgloc $pkgurl 1c9f62f0778697a09d36121ead88e08e

# unpack.
mkdir -p $YHROOT/src
cd $YHROOT/src
tar xf $pkgloc
cd $pkgfull

# build.
{ time ./configure \
  --prefix=$INSTALLDIR \
; } > configure.log 2>&1
#  --with-hdf5=$INSTALLDIR \
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
