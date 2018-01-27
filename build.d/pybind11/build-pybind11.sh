#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

PYTHON=$INSTALLDIR/bin/python3

if [ -z "$FLAVOR" ] ; then
  echo "no hacking environment is set"
  exit 0
else
  rm -rf build/hbuild_$FLAVOR
  mkdir -p build/hbuild_$FLAVOR
  cd build/hbuild_$FLAVOR
fi

# build.
echo "build:"
{ time \
  cmake \
    -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON} \
    -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} \
    ../..
} > build.log 2>&1
echo "built: $(showrealpath build.log)"

echo "start installation:"
{ time \
  make install
} > install.log 2>&1
echo "installation done: $(showrealpath install.log)"

# vim: set et nobomb ff=unix fenc=utf8:
