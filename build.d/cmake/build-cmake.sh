#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download cmake.
pkgname=cmake
pkgverprefix=3.11
pkgver=$pkgverprefix.3
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.xz
pkgurl=https://cmake.org/files/v$pkgverprefix/$pkgfull.tar.gz
download $pkgloc $pkgurl 3f923154ed47128f13b08eacd207d9ee

# unpack.
mkdir -p $YHROOT/src
cd $YHROOT/src
tar xf $pkgloc
cd $pkgfull

# build.
{ time ./configure \
  --prefix=$INSTALLDIR \
; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
