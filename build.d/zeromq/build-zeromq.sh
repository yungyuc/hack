#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download lapack.
zmqname=libzmq
zmqver=4.2.5
zmqfull=$zmqname-$zmqver
zmqloc=$YHDL/${zmqfull}.tar.gz
zmqurl=https://github.com/zeromq/libzmq/archive/v${zmqver}.tar.gz
download $zmqloc $zmqurl da43d89dac623d99909fb95e2725fe05

# unpack.
mkdir -p $YHROOT/src
cd $YHROOT/src
rm -rf $zmqfull
tar xf $zmqloc
mkdir -p $zmqfull/build
cd $zmqfull/build

# build.
{ time cmake \
  -DCMAKE_PREFIX_PATH=$INSTALLDIR \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  .. ; } > cmake.log 2>&1
{ make -j $NP VERBOSE=1 ; } > make.log 2>&1
{ make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:

