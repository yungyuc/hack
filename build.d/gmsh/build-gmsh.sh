#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download gmsh.
pkgname=gmsh
pkgver=${VERSION:-2.16.0}
pkgfull=${pkgname}-${pkgver}-source
pkgloc=$YHDL/$pkgfull.tgz
pkgurl=http://gmsh.info/src/$pkgfull.tgz
download $pkgloc $pkgurl 762c10f159dab4b042e3140b1c348427

# unpack and patch.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

if [ $(uname) == Linux ] ; then
cat > patch << EOF
--- CMakeLists.txt      2018-06-09 22:20:55.284460692 +0800
+++ CMakeLists.txt      2018-06-09 22:20:50.698613586 +0800
@@ -346,6 +346,10 @@
         if(LAPACK_LIBRARIES)
           set_config_option(HAVE_BLAS "Blas(ATLAS)")
           set_config_option(HAVE_LAPACK "Lapack(ATLAS)")
+          find_library(GFORTRAN_LIB libgfortran.so.3)
+          if(GFORTRAN_LIB)
+            list(APPEND LAPACK_LIBRARIES ${GFORTRAN_LIB})
+          endif(GFORTRAN_LIB)
         else(LAPACK_LIBRARIES)
           # try with generic names
           set(GENERIC_LIBS_REQUIRED lapack blas pthread)
@@ -353,7 +357,7 @@
           if(LAPACK_LIBRARIES)
             set_config_option(HAVE_BLAS "Blas(Generic)")
             set_config_option(HAVE_LAPACK "Lapack(Generic)")
-            find_library(GFORTRAN_LIB gfortran)
+            find_library(GFORTRAN_LIB libgfortran.so.3)
             if(GFORTRAN_LIB)
               list(APPEND LAPACK_LIBRARIES ${GFORTRAN_LIB})
             endif(GFORTRAN_LIB)
EOF
patch -p0 < patch
fi

mkdir -p build
cd build

# build.
{ time cmake \
  -DCMAKE_PREFIX_PATH=$INSTALLDIR \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DENABLE_NUMPY=ON \
  -DENABLE_OS_SPECIFIC_INSTALL=OFF \
  -DENABLE_MATCH=OFF \
  -DENABLE_PETSC=OFF \
  -DENABLE_SLEPC=OFF \
  .. ; } > cmake.log 2>&1
{ make -j $NP VERBOSE=1 ; } > make.log 2>&1
{ make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
