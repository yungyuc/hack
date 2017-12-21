#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

PYTHON=$INSTALLDIR/bin/python3

mkdir -p build
cd build

# build.
echo "build:"
{ time \
  cmake \
    -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON} \
    -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} \
    ..
} > install.log 2>&1
echo "built: $(showrealpath build.log)"

echo "start installation:"
{ time \
  make install
} > install.log 2>&1
echo "installation done: $(showrealpath install.log)"

# vim: set et nobomb ff=unix fenc=utf8:
