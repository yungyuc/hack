#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download
pkgname=libuuid
pkgver=${VERSION:-1.0.3}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://sourceforge.net/projects/libuuid/files/$pkgfull.tar.gz/download
download $pkgloc $pkgurl d92ab59aabf5173f2a59089531e30dbf

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
{ time ./configure --prefix=$INSTALLDIR ; } > configure.log 2>&1
{ time make ; } > make.log 2>&1
{ time make INSTALL_DIR=$INSTALLDIR/bin install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
