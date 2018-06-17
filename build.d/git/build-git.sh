#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download git.
pkgname=git
pkgver=${VERSION:-2.17.1}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.xz
pkgurl=https://github.com/git/git/archive/v$pkgver.tar.gz
download $pkgloc $pkgurl 3f923154ed47128f13b08eacd207d9ee

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
make configure
{ time ./configure --prefix=$INSTALLDIR ; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
