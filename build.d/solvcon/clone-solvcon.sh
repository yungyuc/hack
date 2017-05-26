#!/bin/bash
dstdir="solvcon"
if [ -e $dstdir ] ; then
  echo "Destination directory \"$dstdir\" already exists; do nothing"
else
  if [ -z "$READONLY" ] ; then
    git clone git@bitbucket.org:yungyuc/solvcon.git $dstdir
    cd $dstdir
    git remote add public git@github.com:yungyuc/solvcon
    git remote add upstream git@github.com:solvcon/solvcon
  else
    git clone http://github.com/solvcon/solvcon $dstdir
  fi
fi
# vim: set et nobomb ff=unix fenc=utf8:
