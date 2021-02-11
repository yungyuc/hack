#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.
#
# Python development guide: https://docs.python.org/devguide/

pkgname=python
pkgbranch=${VERSION:-master}
pkgfull=$pkgname-$pkgbranch
pkgrepo=https://github.com/python/cpython.git

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
if [ ! -d $pkgfull ] ; then
  git clone -q -b $pkgbranch $pkgrepo $pkgfull
else
  cd $pkgfull
  if [ -z "$NOPULL" ] ; then
    git co $pkgbranch
    git pull origin $pkgbranch
  fi
  cd ..
fi
cd $pkgfull

# build
PREFIX=$INSTALLDIR
ARCH=64
brewssldir=/usr/local/opt/openssl

mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include

if [ $(uname) == Darwin ]; then
  export CPPFLAGS="-I$PREFIX/include -I$brewssldir/include $CPPFLAGS"
  export LDFLAGS="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -L$brewssldir/lib $LDFLAGS"
  sed -i -e "s/@OSX_ARCH@/$ARCH/g" Lib/distutils/unixccompiler.py
elif [ $(uname) == Linux ]; then
  export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
  export LDFLAGS="-L$PREFIX/lib -Wl,-rpath=$PREFIX/lib,--no-as-needed"
fi

cfgcmd=("./configure")
cfgcmd+=("--prefix=$PREFIX")
cfgcmd+=("--enable-shared")
cfgcmd+=("--enable-ipv6")
cfgcmd+=("--with-ensurepip=no")
cfgcmd+=("--enable-optimizations")
cfgcmd+=("--with-lto")
cfgcmd+=("--with-tcltk-includes=-I$PREFIX/include")
cfgcmd+=("--with-tcltk-libs=\"-L$PREFIX/lib -ltcl8.5 -ltk8.5\"")
if [[ $(uname) == Darwin ]] ; then
  #cfgcmd+=("--enable-universalsdk")
  #cfgcmd+=("--with-universal-archs=intel-64")
  #cfgcmd+=("LLVM_AR=/usr/bin/ar")
  cfgcmd+=("--with-openssl=$brewssldir")
fi
#cfgcmd+=("--enable-loadable-sqlite-extensions")
if [[ $FLAVOR == dbg* ]] ; then
  cfgcmd+=("--with-pydebug")
fi

# build.
buildcmd configure.log "${cfgcmd[@]}"
buildcmd make.log make -j $NP
buildcmd install.log make install

#rm -f $PREFIX/bin/python $PREFIX/bin/pydoc
#ln -s $PREFIX/bin/python3.7 $PREFIX/bin/python
#ln -s $PREFIX/bin/pydoc3.7 $PREFIX/bin/pydoc

curl https://bootstrap.pypa.io/get-pip.py | $PREFIX/bin/python3
rm -f $PREFIX/bin/pip

# vim: set et nobomb ff=unix fenc=utf8:
