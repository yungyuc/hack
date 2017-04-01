#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

PYTHON=$INSTALLDIR/bin/python3

# build.
echo "start installation:"
{ time \
  $PYTHON setup.py install --old-and-unmanageable ; \
  $PYTHON setup.py install_headers ; \
} > install.log 2>&1
echo "installation done: $(showrealpath install.log)"

# vim: set et nobomb ff=unix fenc=utf8:
