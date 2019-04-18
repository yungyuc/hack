#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download scotch
pkgname=scotch
pkgver=${VERSION:-6.0.4}
pkgfull=${pkgname}_${pkgver}
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=http://gforge.inria.fr/frs/download.php/file/34618/$pkgfull.tar.gz
download $pkgloc $pkgurl d58b825eb95e1db77efe8c6ff42d329f

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull
cd src # this is the working directory.

# patch.
if [ $(uname) == Darwin ]; then
  patch -p1 < $SCRIPTDIR/scotch_clock_gettime.patch
fi

# build.
echo "prefix = $INSTALLDIR" > Makefile.inc
echo '' >> Makefile.inc
if [ $(uname) == Darwin ]; then
  cat $SCRIPTDIR/scotch_Makefile_darwin.inc >> Makefile.inc
elif [ $(uname) == Linux ]; then
  cat Make.inc/Makefile.inc.x86-64_pc_linux2 | \
    sed -e "s&= -O3&= -fPIC -O3 -I$INSTALLDIR/include&" | \
    sed -e "s&= -lz&= -L$INSTALLDIR/lib -lz&" >> \
    Makefile.inc
fi
export LDFLAGS="-L$INSTALLDIR/lib $LDFLAGS"

buildcmd make.log make -j $NP
cd ..

# install.
mkdir -p $INSTALLDIR/lib
cp lib/* $INSTALLDIR/lib
mkdir -p $INSTALLDIR/bin
cp bin/* $INSTALLDIR/bin
mkdir -p $INSTALLDIR/include
cp include/* $INSTALLDIR/include

# vim: set et nobomb ff=unix fenc=utf8:
