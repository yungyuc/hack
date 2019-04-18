#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download.
pkgname=openssl
pkgver=${VERSION:-1.1.1b}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://www.openssl.org/source/$pkgfull.tar.gz
download $pkgloc $pkgurl 4532712e7bcc9414f5bce995e4e13930

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
buildcmd configure.log ./config \
  --prefix=$INSTALLDIR \
  --openssldir=$INSTALLDIR/share/ssl
buildcmd make.log make -j $NP
buildcmd install.log make -j $NP install

# vim: set et nobomb ff=unix fenc=utf8:
