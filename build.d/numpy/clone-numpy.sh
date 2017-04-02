#!/bin/bash
dstdir="numpy"
if [ -e $dstdir ] ; then
  echo "Destination directory \"$dstdir\" already exists; do nothing"
else
  if [ -z "$READONLY" ] ; then
    git clone git@github.com:numpy/numpy.git $dstdir
  else
    git clone https://github.com/numpy/numpy $dstdir
  fi
fi
# vim: set et nobomb ff=unix fenc=utf8:
