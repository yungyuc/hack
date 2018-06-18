#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download.
pkgname=openssl
pkgver=${VERSION:-1.1.0h}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.xz
pkgurl=https://www.openssl.org/source/$pkgfull.tar.gz
download $pkgloc $pkgurl 5271477e4d93f4ea032b665ef095ff24

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
{ time ./config --prefix=$INSTALLDIR --openssldir=$INSTALLDIR/share/ssl ; } \
  > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make -j $NP install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
