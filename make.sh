#!/bin/bash

#arguments :
#    -j N : use parallel build with N threads
#    -i pathname : install in path pathname


base_path=`pwd`

# install inside this path by default
install_path="${base_path}/install"

# use 2 threads for build, by default
threads=2
source_path=llvm
while getopts "s:j:i:" opt
do
    case $opt in
    s) source_path=$OPTARG ;;
    j) threads=$OPTARG ;;
    i) install_path=$OPTARG ;;
    esac
done

if [ ! -d $source_path ]
then
    echo "ERROR: path $base_path/$source_path does not exist"
    exit
fi

echo ==========================================================================
echo build with $threads threads
echo install in $install_path
echo ==========================================================================

if [ -d build ]
then
    rm -r build
fi
mkdir build

cd build
"../${source_path}/configure" --prefix=${install_path} --enable-optimized

make -j $threads
make install

cd $base_path
