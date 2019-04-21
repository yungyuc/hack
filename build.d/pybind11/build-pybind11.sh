#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=pybind11
pkgbranch=${VERSION:-master}
pkgfull=$pkgname-$pkgbranch
pkgrepo=https://github.com/pybind/pybind11.git

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

if [ -z "$FLAVOR" ] ; then
  echo "no hacking environment is set"
  exit 0
else
  rm -rf build/hbuild_$FLAVOR
  mkdir -p build/hbuild_$FLAVOR
  cd build/hbuild_$FLAVOR
fi

# build.
PYTHON=$INSTALLDIR/bin/python3

cmakecmd=("cmake")
cmakecmd+=("-DPYTHON_EXECUTABLE:FILEPATH=${PYTHON}")
cmakecmd+=("-DCMAKE_INSTALL_PREFIX=${INSTALLDIR}")
cmakecmd+=("-DPYBIND11_TEST=OFF")
if [[ $FLAVOR == opt* ]] ; then
  cmakecmd+=("-DCMAKE_BUILD_TYPE=Release")
elif [[ $FLAVOR == dbg* ]] ; then
  cmakecmd+=("-DCMAKE_BUILD_TYPE=Debug")
fi

buildcmd cmake.log "${cmakecmd[@]}" ../..
buildcmd make.log make -j $NP
buildcmd install.log make install

cd $YHROOT/src/$FLAVOR/$pkgfull
buildcmd build/setup.log $PYTHON setup.py install

# vim: set et nobomb ff=unix fenc=utf8:
