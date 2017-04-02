#!/bin/bash
dstdir="python"
if [ -e $dstdir ] ; then
  echo "Destination directory \"$dstdir\" already exists; do nothing"
else
  if [ -z "$READONLY" ] ; then
    git clone git@github.com:yungyuc/cpython $dstdir
    cd $dstdir
    git remote add upstream git@github.com:python/cpython
  else
    git clone http://github.com/python/cpython $dstdir
  fi
fi
# vim: set et nobomb ff=unix fenc=utf8:
