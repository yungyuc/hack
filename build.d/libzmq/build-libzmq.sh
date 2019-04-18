#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download lapack.
zmqname=libzmq
zmqver=${VERSION:-4.2.5}
zmqfull=$zmqname-$zmqver
zmqloc=$YHDL/${zmqfull}.tar.gz
zmqurl=https://github.com/zeromq/libzmq/archive/v${zmqver}.tar.gz
download $zmqloc $zmqurl da43d89dac623d99909fb95e2725fe05

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $zmqloc
cd $zmqfull

# build again using autotool
if [[ `uname` == Darwin ]]; then
  export LDFLAGS="-Wl,-rpath,$PREFIX/lib $LDFLAGS"
fi

cfgcmd=("./configure")
cfgcmd+=("--prefix=${INSTALLDIR}")

buildcmd autogen.log ./autogen.sh
buildcmd configure.log "${cfgcmd[@]}"
buildcmd make.log make -j
buildcmd install.log make install

# Generate CMake files, so downstream packages can use `find_package(ZeroMQ)`,
# which is normally only available when libzmq is itself installed with CMake

CMAKE_DIR="${INSTALLDIR}/lib/cmake/ZeroMQ"
mkdir -p "$CMAKE_DIR"

cat << EOF > "$CMAKE_DIR/ZeroMQConfig.cmake"
set(PN ZeroMQ)
set(_YH_PREFIX "$INSTALLDIR")
set(\${PN}_INCLUDE_DIR "\${_YH_PREFIX}/include")
set(\${PN}_LIBRARY "\${_YH_PREFIX}/lib/libzmq\${CMAKE_STATIC_LIBRARY_SUFFIX}")
set(\${PN}_STATIC_LIBRARY "\${_YH_PREFIX}/lib/libzmq.a")
unset(_YH_PREFIX)
set(\${PN}_FOUND TRUE)
# add libzmq-$zmqver cmake targets
# only define targets once
# this file can be loaded multiple times
if (TARGET libzmq)
  return()
endif()
add_library(libzmq SHARED IMPORTED)
set_property(TARGET libzmq PROPERTY INTERFACE_INCLUDE_DIRECTORIES "\${\${PN}_INCLUDE_DIR}")
set_property(TARGET libzmq PROPERTY IMPORTED_LOCATION "\${\${PN}_LIBRARY}")
add_library(libzmq-static STATIC IMPORTED "\${\${PN}_INCLUDE_DIR}")
set_property(TARGET libzmq-static PROPERTY INTERFACE_INCLUDE_DIRECTORIES "\${\${PN}_INCLUDE_DIR}")
set_property(TARGET libzmq-static PROPERTY IMPORTED_LOCATION "\${\${PN}_STATIC_LIBRARY}")
EOF

cat << EOF > "$CMAKE_DIR/ZeroMQConfigVersion.cmake"
set(PACKAGE_VERSION "$PKG_VERSION")
# Check whether the requested PACKAGE_FIND_VERSION is compatible
if("\${PACKAGE_VERSION}" VERSION_LESS "\${PACKAGE_FIND_VERSION}")
  set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
  set(PACKAGE_VERSION_COMPATIBLE TRUE)
  if ("\${PACKAGE_VERSION}" VERSION_EQUAL "\${PACKAGE_FIND_VERSION}")
    set(PACKAGE_VERSION_EXACT TRUE)
  endif()
endif()
EOF

# vim: set et nobomb ff=unix fenc=utf8:
