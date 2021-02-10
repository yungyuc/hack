#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=radare2
pkgbranch=${VERSION:-master}
pkgfull=$pkgname-$pkgbranch
pkgrepo=https://github.com/radareorg/radare2

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
if [ ! -d $pkgfull ] ; then
  git clone -q -b $pkgbranch $pkgrepo $pkgfull
else
  cd $pkgfull
  git co $pkgbranch
  git pull origin $pkgbranch
  cd ..
fi
cd $pkgfull

# build.
buildcmd configure.log ./configure --prefix=$INSTALLDIR
buildcmd make.log make -j $NP
buildcmd install.log make install

# vim: set et nobomb ff=unix fenc=utf8:
