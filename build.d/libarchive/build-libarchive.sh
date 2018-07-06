#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.
#
# Python development guide: https://docs.python.org/devguide/

pkgname=libarchive
pkgbranch=${VERSION:-3.2.2}
pkgfull=$pkgname-$pkgbranch
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://www.libarchive.org/downloads/$pkgfull.tar.gz
download $pkgloc $pkgurl 1ec00b7dcaf969dd2a5712f85f23c764

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build
buildcmd configure.log ./configure --prefix=$INSTALLDIR
buildcmd make.log make
buildcmd install.log make install

# vim: set et nobomb ff=unix fenc=utf8:
