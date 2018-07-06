#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download go
pkgname=go
pkgver=${VERSION:-1.10.3}
pkgfull=$pkgname$pkgver
pkgloc=$YHDL/$pkgfull.src.tar.gz
pkgurl=https://dl.google.com/$pkgname/$pkgfull.src.tar.gz
download $pkgloc $pkgurl d15dfb264105c5e84fbe33f4a4aa5021

pkg_boot_full=go1.4-bootstrap-20171003
pkg_boot_loc=$YHDL/$pkg_boot_full.tar.gz
pkg_boot_url=https://dl.google.com/go/$pkg_boot_full.tar.gz
download $pkg_boot_loc $pkg_boot_url dbf727a4b0e365bf88d97cbfde590016

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
# bootstrap files.
mkdir -p go-bootstrap
cd go-bootstrap
tar xf $pkg_boot_loc
cd ..
# real files.
mkdir -p $YHROOT/usr/$FLAVOR
cd $YHROOT/usr/$FLAVOR
rm -rf $pkgname-bak
if [ -d $pkgname ] ; then
  mv $pkgname $pkgname-bak
fi
tar xf $pkgloc

# build.
export GOOS=linux
export GOARCH=amd64

echo "start bootstrap:"
cd $YHROOT/src/$FLAVOR/go-bootstrap/go/src
{ time env CGO_ENABLED=0 ./make.bash ; } > make.log 2>&1
cd ../../..
echo "bootstrap done: $(showrealpath go-bootstrap/go/src/make.log)"

export GOROOT=$INSTALLDIR/$pkgname
export GOROOT_BOOTSTRAP="$(cd go-bootstrap/go && pwd)"

# https://github.com/golang/go/issues/20796
echo "start all:"
cd $GOROOT/src
if [ $(uname) == Linux ]; then
  patch -p1 < $SCRIPTDIR/exec_linux_test.go-centos7.patch
fi
{ time ./all.bash ; } > all.log 2>&1
cd ../..
echo "all done: $(showrealpath $pkgname/src/all.log)"

mkdir -p $INSTALLDIR/gopath

# vim: set et nobomb ff=unix fenc=utf8:
