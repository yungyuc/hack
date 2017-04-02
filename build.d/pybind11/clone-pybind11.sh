#!/bin/bash
dstdir="pybind11"
if [ -e $dstdir ] ; then
  echo "Destination directory \"$dstdir\" already exists; do nothing"
else
  if [ -z "$READONLY" ] ; then
    git clone git@github.com:yungyuc/pybind11.git $dstdir
    cd $dstdir
    git remote add upstream git@github.com:pybind/pybind11.git
  else
    git clone http://github.com/pybind/pybind11.git $dstdir
  fi
fi
# vim: set et nobomb ff=unix fenc=utf8:
