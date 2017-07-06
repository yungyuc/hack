#!/bin/bash
dstdir="modmagic"
if [ -e $dstdir ] ; then
  echo "Destination directory \"$dstdir\" already exists; do nothing"
else
  if [ -z "$READONLY" ] ; then
    git clone git@bitbucket.org:yungyuc/modmagic.git $dstdir
  else
    git clone http://github.com/modmagic/modmagic $dstdir
  fi
fi
# vim: set et nobomb ff=unix fenc=utf8:
