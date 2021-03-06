#! /bin/sh -e

# setup environment variables
OS=$(uname -s)
CWD=`pwd`
PROJECT_ROOT="$CWD/.."
LLVM_SRC="$PROJECT_ROOT/llvm"
LLVM_BUILD="$PROJECT_ROOT/build/llvm"
LLVM_INSTALL="$PROJECT_ROOT/build/llvm-install"

# clean clang build directory
if [ $# -eq 1 ] && [ "$1" = "clean" ]; then
    rm -rf $LLVM_BUILD
    rm -rf $LLVM_INSTALL
    exit 0
fi

# configure for release build
RELEASE_CONFIG=""
if [ $# -eq 1 ] && [ "$1" = "release" ]; then
    RELEASE_CONFIG="-D CMAKE_BUILD_TYPE=Release"
else
    RELEASE_CONFIG="-D CMAKE_BUILD_TYPE=Debug"
fi

# create directory and prepare for build
mkdir -p $LLVM_BUILD
cd $LLVM_BUILD

if [ "$CPU_CORES" = "" ]; then
    # Default to building on all cores, but allow single core builds using:
    # "CPU_CORES=1 ./buildClang.sh release"
    CPU_CORES=1
    if [ "$OS" = "Linux" ]; then
        CPU_CORES=$(grep -c ^processor /proc/cpuinfo)
    elif [ "$OS" = "Darwin" ]; then
        CPU_CORES=$(sysctl -n hw.ncpu)
    fi
fi

# configure and build
if [ "$OS" = "Darwin" ]; then
    DARWIN_VERSION=`sysctl -n kern.osrelease | cut -d . -f 1`
    if [ $DARWIN_VERSION -lt 13 ]; then
        cmake $RELEASE_CONFIG -D CMAKE_CXX_FLAGS="-std=c++11 -stdlib=libc++ ${CMAKE_CXX_FLAGS}" -D CMAKE_INSTALL_PREFIX=$LLVM_INSTALL $LLVM_SRC
    else
        cmake $RELEASE_CONFIG -D CMAKE_INSTALL_PREFIX=$LLVM_INSTALL $LLVM_SRC
    fi
else
    cmake $RELEASE_CONFIG -D CMAKE_INSTALL_PREFIX=$LLVM_INSTALL $LLVM_SRC
fi
make -j $CPU_CORES
make install

# back to the current folder
cd $CWD
