#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download cmake.
pkgname=Cython
pkgver=${VERSION:-0.29.21}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://files.pythonhosted.org/packages/6c/9f/f501ba9d178aeb1f5bf7da1ad5619b207c90ac235d9859961c11829d0160/$pkgfull.tar.gz
download $pkgloc $pkgurl 12c5e45af71dcc6dff28cdcbcbef6f39

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
PYTHON=$INSTALLDIR/bin/python3

buildcmd build.log $PYTHON setup.py build -j $NP
buildcmd install.log $PYTHON setup.py install

# vim: set et nobomb ff=unix fenc=utf8:
