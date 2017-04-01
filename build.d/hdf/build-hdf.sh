#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download netcdf.
pkgname=hdf5
pkgver=1.8.18
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.bz2
pkgurl=https://support.hdfgroup.org/ftp/HDF5/current18/src/$pkgfull.tar.bz2
download $pkgloc $pkgurl 29117bf488887f89888f9304c8ebea0b

# unpack.
mkdir -p $YHROOT/src
cd $YHROOT/src
tar xf $pkgloc
cd $pkgfull

# build.
{ time ./configure \
  --prefix=$INSTALLDIR \
  --enable-cxx \
; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
