#!/bin/bash
if [ -f $YHROOT/etc/bashutils.sh ]; then source $YHROOT/etc/bashutils.sh; fi

if [ "$(uname)" == "Darwin" ] ; then
  NP=${NP:=$(sysctl -n hw.ncpu)}
elif [ "$(uname)" == "Linux" ] ; then
  NP=${NP:=$(cat /proc/cpuinfo | grep processor | wc -l)}
else
  NP=${NP:=1}
fi
export NP

export SCRIPTDIR=${SCRIPTDIR:=$YHROOT/build.d/$1}
if [ ! -d "$SCRIPTDIR" ]; then
  echo "Script directory \"$SCRIPTDIR\" doesn't exist"
  exit
fi

FLAVOR="${FLAVOR:=opt}"

export INSTALLDIR=$YHROOT/usr/$FLAVOR
mkdir -p $INSTALLDIR

namemunge PATH $INSTALLDIR/bin
if [ $(uname) == Darwin ] ; then
  namemunge DYLD_LIBRARY_PATH $INSTALLDIR/lib
elif [ $(uname) == Linux ] ; then
  namemunge LD_LIBRARY_PATH $INSTALLDIR/lib
fi

buildcmd () {
  echo "run command: ${@:2}"
  { time "${@:2}" ; } > $1 2>&1
  echo "done; log file: $(showrealpath $1)"
}
export -f buildcmd

# vim: set et nu nobomb fenc=utf8 ft=sh ff=unix sw=2 ts=2:
