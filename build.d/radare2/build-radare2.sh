#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=radare2
pkgver=${VERSION:-3.4.1}
pkgfull=$pkgname-$pkgver
pkgurl=https://github.com/radare/${pkgname}/archive/${pkgver}.tar.gz
pkgloc=$YHDL/$pkgfull.tar.gz
download $pkgloc $pkgurl 119dbd16ffac0338aaa2d1eca9635b5f

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
buildcmd configure.log ./configure --prefix=$INSTALLDIR
buildcmd make.log make -j $NP
buildcmd install.log make install

cd $YHROOT/src/$FLAVOR/$pkgfull
buildcmd build/setup.log $PYTHON setup.py install

# vim: set et nobomb ff=unix fenc=utf8:
