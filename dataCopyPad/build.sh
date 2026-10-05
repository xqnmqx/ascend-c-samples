rm -rf ./build
mkdir -p build
cd build
# Compile
cmake .. ${cmake_args}
make -j VERBOSE=1
