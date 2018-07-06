#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download squashfs-tools
pkgname=squashfs
pkgver=${VERSION:-4.3}
pkgfull=$pkgname$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://sourceforge.net/projects/squashfs/files/$pkgname/$pkgfull/$pkgfull.tar.gz/download
download $pkgloc $pkgurl d92ab59aabf5173f2a59089531e30dbf

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull/squashfs-tools

# build.
export C_INCLUDE_PATH=$INSTALLDIR/include
export LIBRARY_PATH=$INSTALLDIR/lib
{ time make ; } > make.log 2>&1
{ time make INSTALL_DIR=$INSTALLDIR/bin install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
