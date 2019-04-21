#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download netcdf.
pkgname=zlib
pkgver=${VERSION:-1.2.11}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.xz
pkgurl=https://zlib.net/$pkgfull.tar.gz
download $pkgloc $pkgurl 1c9f62f0778697a09d36121ead88e08e

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
buildcmd configure.log ./configure --prefix=$INSTALLDIR
buildcmd make.log make -j $NP
buildcmd install.log make install

# vim: set et nobomb ff=unix fenc=utf8:
