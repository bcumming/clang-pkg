#!/bin/bash

LLVMBASE=`pwd`

# by defauot we check out the trunk, aka "latest"
# use the -v flag to get a particular version
# the version name should correspond to a tag number
# to get a list of tags:
#       svn ls http://llvm.org/svn/llvm-project/llvm/tags

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

svn co http://llvm.org/svn/llvm-project/llvm/$base "$path"

# checkout Clang
cd ${LLVMBASE}
cd $path/tools
svn co http://llvm.org/svn/llvm-project/cfe/$base clang

# checkout Compiler-RT
cd ${LLVMBASE}
cd $path/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/$base compiler-rt

#Get the Test Suite Source Code [Optional]
cd ${LLVMBASE}
cd $path/projects
svn co http://llvm.org/svn/llvm-project/test-suite/$base test-suite

cd ${LLVMBASE}

