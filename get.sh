#!/bin/bash

LLVMBASE=`pwd`

# by default we check out the trunk, aka "latest"
# use the -v flag to get a particular version
# the version name should correspond to a tag number
# to get a list of tags:
#       svn ls http://llvm.org/svn/llvm-project/llvm/tags
# for example, the tag for version 3.4 is
#       RELEASE_34
# so we would use the following to check it out
#       ./get.sh -v RELEASE_34

version=latest
while getopts "v:" opt
do
    case $opt in
    v) version=$OPTARG ;;
    esac
done

# checkout llvm
if [ X"latest" = X"$version" ]
then
    base="trunk"
    path="llvm"
else
    base="tags/$version"
    path="$version"
fi

echo =======================================
echo checking out $version version of llvm+clang
echo "  $base --> $path"
echo =======================================

echo =======================================
echo llvm/$base
echo =======================================
svn export http://llvm.org/svn/llvm-project/llvm/$base "$path" > ${LLVMBASE}/log.llvm

# checkout Clang
echo =======================================
echo cfe/$base
echo =======================================
cd ${LLVMBASE}
cd $path/tools
svn export http://llvm.org/svn/llvm-project/cfe/$base clang > ${LLVMBASE}/log.clang

# checkout Compiler-RT
echo =======================================
echo compiler-rt/$base
echo =======================================
cd ${LLVMBASE}
cd $path/projects
svn export http://llvm.org/svn/llvm-project/compiler-rt/$base compiler-rt > ${LLVMBASE}/log.compiler-rt

#Get the Test Suite Source Code [Optional]
#echo =======================================
#echo test-suite/$base
#echo =======================================
#cd ${LLVMBASE}
#cd $path/projects
#svn export http://llvm.org/svn/llvm-project/test-suite/$base test-suite

cd ${LLVMBASE}

# workaround SUSE Linux header conflict with keyword new
header="${path}/projects/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.cc"
if [ -f "$header" ]
then
    echo =======================================
    echo fixing dodgy header
    echo =======================================
    sed -i 's|#include <sys\/vt.h>|#define new WORKAROUNDFIX\n#include <sys\/vt.h>\n#undef new|g' "${header}"
fi


