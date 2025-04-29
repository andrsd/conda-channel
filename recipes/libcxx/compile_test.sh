set -xe

LINK_FLAGS="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -Wl,-v -v"

# target platform is empty here now
if [[ "$target_platform" == osx* ]]; then
    llvm-nm $PREFIX/lib/libc++.1.dylib
    CONDA_BUILD_SYSROOT=$(xcrun --show-sdk-path)
    COMPILE_FLAGS="-isysroot $CONDA_BUILD_SYSROOT"
else
    LINK_FLAGS="${LINK_FLAGS} -lc++abi"
    COMPILE_FLAGS=""
fi

FILES=test_sources/*.c
for f in $FILES
do
    clang -O2 -g $COMPILE_FLAGS $f $LINK_FLAGS
    ./a.out
done

FILES=test_sources/*.cpp
for f in $FILES
do
    clang++ -stdlib=libc++ -O2 -g $COMPILE_FLAGS $f $LINK_FLAGS
    ./a.out
done

FILES=test_sources/cpp11/*.cpp
for f in $FILES
do
    clang++ -stdlib=libc++ -std=c++11 -O2 -g $COMPILE_FLAGS $f $LINK_FLAGS
    ./a.out
done

FILES=test_sources/cpp14/*.cpp
for f in $FILES
do
    clang++ -stdlib=libc++ -std=c++14 -O2 -g $COMPILE_FLAGS $f $LINK_FLAGS
    ./a.out
done