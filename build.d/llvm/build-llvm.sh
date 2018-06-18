#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

#download $pkgloc $pkgurl 3f923154ed47128f13b08eacd207d9ee

tarext=tar.xz
version=${VERSION:-6.0.0}

llvm_full=llvm-$version.src
llvm_loc=$YHDL/$llvm_full.$tarext
llvm_url=http://releases.llvm.org/$version/$llvm_full.$tarext
download $llvm_loc $llvm_url 788a11a35fa62eb008019b37187d09d2

clang_full=cfe-$version.src
clang_loc=$YHDL/$clang_full.$tarext
clang_url=http://releases.llvm.org/$version/$clang_full.$tarext
download $clang_loc $clang_url 121b3896cb0c7765d690acc5d9495d24

clext_full=clang-tools-extra-$version.src
clext_loc=$YHDL/$clext_full.$tarext
clext_url=http://releases.llvm.org/$version/$clext_full.$tarext
download $clext_loc $clext_url 6b1d543116dab5a3caba10091d983743

omp_full=openmp-$version.src
omp_loc=$YHDL/$omp_full.$tarext
omp_url=http://releases.llvm.org/$version/$omp_full.$tarext
download $omp_loc $omp_url eb6b8d0318a950a8192933a3b500585d

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR

tar xf $llvm_loc
cd $llvm_full

cd tools
tar xf $clang_loc
mv $clang_full clang
cd ..

cd tools/clang/tools
tar xf $clext_loc
mv $clext_full extra
cd ../../..

cd projects
tar xf $omp_loc
mv $omp_full openmp
cd ..

if [ -z "$FLAVOR" ] ; then
  echo "no hacking environment is set"
  exit 0
else
  rm -rf build/hbuild_$FLAVOR
  mkdir -p build/hbuild_$FLAVOR
  cd build/hbuild_$FLAVOR
fi

# build.
cmakecmd=("cmake")
cmakecmd+=("-DCMAKE_BUILD_TYPE=MinSizeRel")
cmakecmd+=("-DCMAKE_INSTALL_PREFIX=${INSTALLDIR}")

echo "configuration:"
{ time "${cmakecmd[@]}" ../.. ; } > cmake.log 2>&1
echo "configuration done"

echo "build:"
{ time make -j $NP ; } > make.log 2>&1
echo "built"

echo "install:"
{ time make install ; } > install.log 2>&1
echo "installation done"

# vim: set et nobomb ff=unix fenc=utf8:
