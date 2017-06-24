#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.
#
# Python development guide: https://docs.python.org/devguide/

PREFIX=$INSTALLDIR
ARCH=64

mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include

if [ $(uname) == Darwin ]; then
  export CPPFLAGS="-I$PREFIX/include -I/usr/local/opt/openssl/include $CPPFLAGS"
  export LDFLAGS="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -L/usr/local/opt/openssl/lib -headerpad_max_install_names $LDFLAGS"
  sed -i -e "s/@OSX_ARCH@/$ARCH/g" Lib/distutils/unixccompiler.py
elif [ $(uname) == Linux ]; then
  export CPPFLAGS="-I$PREFIX/include"
  export LDFLAGS="-L$PREFIX/lib -Wl,-rpath=$PREFIX/lib,--no-as-needed"
fi

cfgcmd=("./configure")
cfgcmd+=("--prefix=$PREFIX")
cfgcmd+=("--enable-shared")
cfgcmd+=("--enable-ipv6")
cfgcmd+=("--with-ensurepip=no")
cfgcmd+=("--with-tcltk-includes=-I$PREFIX/include")
cfgcmd+=("--with-tcltk-libs=\"-L$PREFIX/lib -ltcl8.5 -ltk8.5\"")
#cfgcmd+=("--enable-loadable-sqlite-extensions")
if [ "$FLAVOR" == "dbg" ] ; then
  cfgcmd+=("--with-pydebug")
fi

echo "start configuration:"
echo "${cfgcmd[@]}"
{ time "${cfgcmd[@]}" ; } > configure.log 2>&1
echo "configuration done: $(showrealpath configure.log)"

echo "start building:"
{ time make -j $NP ; } > make.log 2>&1
echo "build done: $(showrealpath make.log)"

echo "start installation to ($PREFIX):"
{ time make install ; } > install.log 2>&1
echo "installation done: $(showrealpath install.log)"

#rm -f $PREFIX/bin/python $PREFIX/bin/pydoc
#ln -s $PREFIX/bin/python3.7 $PREFIX/bin/python
#ln -s $PREFIX/bin/pydoc3.7 $PREFIX/bin/pydoc

curl https://bootstrap.pypa.io/get-pip.py | $PREFIX/bin/python3
rm -f $PREFIX/bin/pip

# vim: set et nobomb ff=unix fenc=utf8:
