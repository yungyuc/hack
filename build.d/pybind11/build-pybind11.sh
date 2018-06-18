#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=pybind11
pkgbranch=${VERSION:-master}
pkgfull=$pkgname-$pkgbranch
pkgrepo=http://github.com/pybind/pybind11.git

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
if [ ! -d $pkgrepo ] ; then
  git clone -b $pkgbranch $pkgrepo $pkgfull
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
if [[ $FLAVOR == opt* ]] ; then
  cmakecmd+=("-DCMAKE_BUILD_TYPE=Release")
elif [[ $FLAVOR == dbg* ]] ; then
  cmakecmd+=("-DCMAKE_BUILD_TYPE=Debug")
fi

echo "configuration:"
{ time "${cmakecmd[@]}" ../.. ; } > cmake.log 2>&1
echo "configuration done: $(showrealpath cmake.log)"

echo "make:"
{ time make ; } > make.log 2>&1
echo "make done: $(showrealpath make.log)"

echo "install:"
{ time make install ; } > install.log 2>&1
echo "make done: $(showrealpath install.log)"

# vim: set et nobomb ff=unix fenc=utf8:
