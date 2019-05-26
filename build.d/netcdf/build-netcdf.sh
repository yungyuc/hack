#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download netcdf.
pkgname=netcdf
pkgver=${VERSION:-4.4.1.1}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=ftp://ftp.unidata.ucar.edu/pub/$pkgname/$pkgfull.tar.gz
download $pkgloc $pkgurl 503a2d6b6035d116ed53b1d80c811bda

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
# --with-hdf5 doesn't work:
# http://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg10457.html
{ time LDFLAGS=-L$INSTALLDIR/lib CPPFLAGS=-I$INSTALLDIR/include ./configure \
  --prefix=$INSTALLDIR \
  --enable-netcdf4 \
  --disable-fortran \
  --disable-dap \
  --enable-shared \
; } > configure.log 2>&1
#  --with-hdf5=$INSTALLDIR \
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
