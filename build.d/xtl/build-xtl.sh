#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=xtl
pkgbranch=${VERSION:-master}
pkgfull=$pkgname-$pkgbranch
pkgrepo=https://github.com/QuantStack/$pkgname.git

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
if [ ! -d $pkgfull ] ; then
  git clone -q -b $pkgbranch $pkgrepo $pkgfull
else
  cd $pkgfull
  if [[ `git branch | grep \* | cut -d ' ' -f2` == $pkgbranch ]] ; then
    git co $pkgbranch
    git pull origin $pkgbranch
  fi
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
cmakecmd=("cmake")
cmakecmd+=("-DCMAKE_INSTALL_PREFIX=${INSTALLDIR}")
if [[ $FLAVOR == opt* ]] ; then
  cmakecmd+=("-DCMAKE_BUILD_TYPE=Release")
elif [[ $FLAVOR == dbg* ]] ; then
  cmakecmd+=("-DCMAKE_BUILD_TYPE=Debug")
fi

buildcmd cmake.log "${cmakecmd[@]}" ../..
buildcmd make.log make
buildcmd install.log make install

# vim: set et nobomb ff=unix fenc=utf8:
