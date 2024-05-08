#!/bin/bash

set -euxo pipefail

# Intel LLVM must cooperate with compiler and sysroot from conda
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}:${BUILD_PREFIX}/lib"

echo "--gcc-toolchain=${BUILD_PREFIX} --sysroot=${BUILD_PREFIX}/${HOST}/sysroot -target ${HOST}" > icpx_for_conda.cfg
ICPXCFG="$(pwd)/icpx_for_conda.cfg"
ICXCFG="$(pwd)/icpx_for_conda.cfg"

read -r GLIBC_MAJOR GLIBC_MINOR <<<"$(conda list '^sysroot_linux-64$' \
    | tail -n 1 | awk '{print $2}' | grep -oP '\d+' | head -n 2 | tr '\n' ' ')"

export ICXCFG
export ICPXCFG

export CC=icx
export CXX=icpx

export CMAKE_GENERATOR=Ninja
# Make CMake verbose
export VERBOSE=1

# new llvm-spirv location
# starting from dpcpp_impl_linux-64=2022.0.0=intel_3610
# export PATH=$CONDA_PREFIX/bin-llvm:$PATH

    # -DCMAKE_INSTALL_PREFIX:STRING=${PREFIX} \
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_WITH_MPI=OFF \
    -DCMAKE_INSTALL_PREFIX:STRING=./tools/unitrace/install \
    -S ./tools/unitrace \
    -B ./tools/unitrace/build 
cmake --build ./tools/unitrace/build
# ninja -j1 -C ./tools/unitrace/build
# cmake --install ./tools/unitrace/build --prefix=$PREFIX
cmake --install ./tools/unitrace/build --prefix=./tools/unitrace/install
cp ./tools/unitrace/install/bin/unitrace $PREFIX/bin/
cp ./tools/unitrace/install/bin/libunitrace_tool.so $PREFIX/bin/
rm -rf ./tools/unitrace/install
rm -rf ./tools/unitrace/build
